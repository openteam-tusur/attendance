class EducationDepartment::StudentsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  authorize_resource

  def show
    @charts = {}

    @group = Group.actual.find_by(:number => params[:group_id])
    @course = params[:course_id]
    @faculty = params[:faculty_id]
    @student = @group.students.actual.find{|s| s.to_s == params[:id] }
    @omissions = @student.presences.by_state(:wasnt).between_dates(*filter_params.values)

    student_statistic = Statistic::Student.new(@student.contingent_id, nil)

    if params.to_a[-3..-2][0][0] == 'course_id'
      @parent_url = education_department_faculty_course_group_path(@faculty, @course, @group.number, :filter => params[:filter])
    else
      @parent_url = education_department_course_faculty_group_path(@course, @faculty, @group.number, :filter => params[:filter])
    end

    @charts['attendance_by_dates.line']      = student_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_disciplines.bar'] = student_statistic.attendance_by('disciplines', **filter_params)
  end
end
