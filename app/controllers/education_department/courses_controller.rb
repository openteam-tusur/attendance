class EducationDepartment::CoursesController < AuthController
  include FilterParams
  include DateRange

  def show
    @charts = {}
    @course = params[:id]

    if params.to_a[-2..-2][0][0] == 'faculty_id'
      @parent_url = education_department_faculty_path(params[:faculty_id], :filter => params[:filter])
    else
      @parent_url = education_department_faculties_path(:filter => params[:filter])
    end

    if params[:faculty_id]
      faculty_statistic = Statistic::Faculty.new("#{params[:faculty_id]}:#{@course}", "#{current_namespace}/faculties/#{params[:faculty_id]}/courses/#{@course}")
      @charts['attendance_by_dates.line']          = faculty_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_groups.bar']          = faculty_statistic.attendance_by('groups', **filter_params)
    else
      course_statistic = Statistic::University.new("#{@course}", "#{current_namespace}/courses/#{@course}")
      @charts['attendance_by_dates.line']          = course_statistic.attendance_by_date(**filter_params)
      @charts['attendance_by_faculties.bar']       = course_statistic.attendance_by('faculties', **filter_params)
    end
  end
end
