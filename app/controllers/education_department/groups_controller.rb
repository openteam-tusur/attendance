class EducationDepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @group = Group.actual.find_by(:number => params[:id])
    @course = params[:course_id]
    @faculty = params[:faculty_id]

    if params.to_a[-3..-2][0][0] == 'course_id'
      @parent_url = education_department_course_faculty_path(@course, @faculty, :filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, "#{current_namespace}/courses/#{@course}/faculties/#{@faculty}/groups/#{@group}")
    else
      @parent_url = education_department_faculty_course_path(@faculty, @course, :filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, "#{current_namespace}/faculties/#{@faculty}/courses/#{@course}/groups/#{@group}")
    end

    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end
end
