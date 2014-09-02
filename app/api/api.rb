class API < Grape::API
  format :json
  prefix :api

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
      where('lessons.id' => lesson_ids, 'lessons.group_id' => group.id)

    misses = student.
      misses.
      between_dates(student.semester_begin, student.semester_end)

    presences.each do |p|
      p.state = 'valid_excuse' if p.state == 'wasnt' && misses.where('misses.starts_at <= ? AND misses.ends_at >= ?', LessonTime.new(p.lesson.order_number, p.lesson.date_on).lesson_time).any?
    end

    presences
      .group_by { |p| p.lesson.kind }
      .map { |k, p| { k => p.group_by(&:state).map { |kind, presences| { kind => presences.count  }  }.reduce(&:merge)  } }.reduce(&:merge) || { :error => 'Presence not found'  }

  end
end
