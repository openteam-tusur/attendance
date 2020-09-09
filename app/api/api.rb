class API < Grape::API
  format :json
  prefix :api

  helpers do
    def calculate_dates_for(year, semester_kind)
      years = year.split(?/).map(&:to_i)
      if semester_kind == 'autumn'
        year = years.first
        start_date = Date.new year, 9, 1
        end_date = Date.new year, 12, 31
      else
        year = years.last
        start_date = Date.new year, 1, 1
        end_date = Date.new year, 8, 31
      end
      [start_date, end_date]
    end

    def group_leader_for(group)
      return nil unless group
      leader = group.group_leaders.first
      return nil unless leader
      {
        fullname: leader.fullname,
        email:    leader.email,
        id:       leader.id
      }
    end
  end

  params do
    requires :group,      type: String, desc: "Group number"
    requires :student,    type: String, desc: "Student full name"
    requires :discipline, type: String, desc: "Discipline title"
  end

  get :attendance do
    group = Group.find_by_number(params[:group])
    return { :error => 'Group not found'  } if group.nil?

    surname, name, patronymic = params[:student].split(/\s/, 3)
    student = group.students.find_by_name_and_patronymic_and_surname(name, patronymic, surname)
    return { :error => 'Student not found'  } if student.nil?

    discipline = Discipline.find_by_title(params[:discipline])
    return { :error => 'Discipline not found'  } if discipline.nil?

    lesson_ids = discipline.lesson_ids


    presences = student.
      presences.
      between_dates(student.semester_begin, student.semester_end).
      where('lessons.id' => lesson_ids, 'lessons.group_id' => group.id).where.not(:state => nil)

    misses = student.
      misses.
      between_dates(student.semester_begin, student.semester_end)

    presences.each do |p|
      p.state = 'valid_excuse' if p.state == 'wasnt' && misses.where('misses.starts_at <= :time AND misses.ends_at >= :time', :time => LessonTime.new(p.lesson.order_number, p.lesson.date_on, p.lesson.training_shift).lesson_time).any?
    end

    presences
      .group_by { |p| p.lesson.kind }
      .map { |k, p| { k => p.group_by(&:state).map { |kind, presences| { kind => presences.count  }  }.reduce(&:merge)  } }.reduce(&:merge) || { :error => 'Presence not found'  }

  end

  params do
    requires :group_number,     type: String, desc: 'Group number'
    requires :student_ids,      type: Array,  desc: 'Student contingent ids'
    requires :semester_year,    type: String, desc: 'Semester academic year'
    requires :semester_kind,    type: String, desc: 'Semester kind'
    requires :discipline_title, type: String, desc: 'Title of discipline'
  end

  post :group_attendance do
    result = {}
    group = Group.find_by number: params[:group_number]
    return result.merge!({ error: 'Group not found'  }) unless group

    result[:group_leader] = group_leader_for group
    students = Student.where(contingent_id: params[:student_ids])
    students_ids = students.pluck(:id)

    return result.merge!({ error: 'Student not found'  }) if students.empty?

    discipline = Discipline.find_by title: params[:discipline_title]
    return result.merge!({ error: 'Discipline not found'  }) unless discipline.present?
    lesson_ids = discipline.lesson_ids


    start, finish = calculate_dates_for params.semester_year, params.semester_kind
    presences = Presence
                .joins(:student)
                .includes(:lesson, :student)
                .between_dates(start, finish)
                .where('lessons.id IN (?) AND lessons.group_id = ?', lesson_ids, group.id)
                .where(people: { id: students_ids })
                .where('state IS NOT NULL')
                .group_by(&:student)

    misses = Miss.joins("INNER JOIN people ON misses.missing_id = people.id")
                 .between_dates(start, finish)
                 .where(missing_type: "Student")
                 .where("people.id IN (?)", students_ids)
                 .group_by(&:missing)
    available_kinds = []
    presences.each do |student, presences|
      presences.each do |p|
        if p.state == 'wasnt' && misses[student]
          lesson_time = LessonTime.new(p.lesson.order_number, p.lesson.date_on, p.lesson.training_shift)
                                  .lesson_time
          p.state = 'valid_excuse' if misses[student].find{ |miss| miss.starts_at <= lesson_time && miss.ends_at >= lesson_time }
        end

      end
      statistic = presences
        .group_by { |p| p.lesson.kind }
        .map do |k, p|
          available_kinds << k
          {
            k => p.group_by(&:state)
                    .map { |kind, presences| { kind => presences.size }  }
                    .reduce(&:merge)
          }
         end.reduce(&:merge)
      statistic ||= { :error => 'Presence not found'  }
      result[student.contingent_id] = statistic
    end

    # Сортировка типов занятий 'как принято в ТУСУРе'
    # в локализации типы занятий лежат в 'правильном' порядке
    # после объединения массивов типы зантяй получается в необходимом порядке
    sorted_kinds = I18n.t('lesson.kind').keys.map(&:to_s) & available_kinds.uniq
    result['available_kinds'] = sorted_kinds
    result
  end

  params do
    requires :group_number,     type: String, desc: 'Group number'
  end

  post :group_leader do
    group = Group.find_by(number: params[:group_number])
    { group_leader: group_leader_for(group) }
  end
end
