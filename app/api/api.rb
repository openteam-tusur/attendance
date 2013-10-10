class API < Grape::API
  prefix :api
  format :json

  params do
    requires :group,      type: String, desc: "Group number"
    requires :student,    type: String, desc: "Student full name"
    requires :discipline, type: String, desc: "Discipline title"
  end
  get :attendance do
    group = Group.find_by_number(params[:group])
    return { :error => 'Group not found' } if group.nil?

    surname, name, patronymic = params[:student].split(/\s/)
    student = group.students.find_by_name_and_patronymic_and_surname(name, patronymic, surname)
    return { :error => 'Student not found' } if student.nil?

    discipline = Discipline.find_by_title(params[:discipline])
    return { :error => 'Discipline not found' } if discipline.nil?

    lesson_ids = discipline.lesson_ids
    student.presences.from_semester_begin.where('lessons.id' => lesson_ids).group_by(&:kind).map{|a,b| { a => b.count }}.reduce(:merge)
  end
end
