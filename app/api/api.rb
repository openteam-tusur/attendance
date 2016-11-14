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
      p.state = 'valid_excuse' if p.state == 'wasnt' && misses.where('misses.starts_at <= :time AND misses.ends_at >= :time', :time => LessonTime.new(p.lesson.order_number, p.lesson.date_on).lesson_time).any?
    end

    presences
      .group_by { |p| p.lesson.kind }
      .map { |k, p| { k => p.group_by(&:state).map { |kind, presences| { kind => presences.count  }  }.reduce(&:merge)  } }.reduce(&:merge) || { :error => 'Presence not found'  }

  end

  params do
    requires :group_number,            type: String, desc: "Group number"
    requires :student_ids,      type: Array, desc: 'Student contingent ids'
    requires :semester_year,    type: String, desc: 'Semester academic year'
    requires :semester_kind,    type: String, desc: 'Semester kind'
    requires :discipline_title, type: String, desc: 'Title of discipline'
  end

  post :group_attendance do
    students = Student.where(contingent_id: params[:student_ids])
    return { error: 'Student not found'  } if students.empty?
    result = []
    start, finish = calculate_dates_for params.semester_year, params.semester_kind
    discipline = Discipline.find_by title: params[:discipline_title]
    return { error: 'Discipline not found'  } unless discipline.present?
    group = Group.find_by number: params[:group_number]
    return { error: 'Group not found'  } unless group
    lesson_ids = discipline.lesson_ids
    students.each do |student|
      presences = student
        .presences.between_dates(start, finish)
        .where('lessons.id IN (?) AND lessons.group_id = ?', lesson_ids, group.id)
        .where('state IS NOT NULL')

      misses = student.misses.between_dates(start, finish)

      presences.each do |p|
        p.state = 'valid_excuse' if p.state == 'wasnt' && misses.where('misses.starts_at <= :time AND misses.ends_at >= :time', :time => LessonTime.new(p.lesson.order_number, p.lesson.date_on).lesson_time).any?
      end

      statistic = presences
        .group_by { |p| p.lesson.kind }
        .map do |k, p|
          value = p.group_by(&:state)
                    .map { |kind, presences| { kind => presences.size }  }
                    .reduce(&:merge)
         end.reduce(&:merge)
      statistic ||= { :error => 'Presence not found'  }
      statistic[:student_id] = student.id
      result << statistic
    end
    result
  end
end
