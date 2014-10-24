class Subdepartment::GroupsController < AuthController
  include FilterParams
  include DateRange

  inherit_resources
  load_and_authorize_resource

  defaults :finder => :find_by_number

  before_filter :find_subdepartment

  def index
    @charts = {}
    subdepartment_statistic = Statistic::Subdepartment.new(@subdepartment, current_namespace)

    @charts['attendance_by_dates.line']  = subdepartment_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_courses.bar'] = subdepartment_statistic.attendance_by('courses', **filter_params)
    @charts['attendance_by_groups.bar']  = subdepartment_statistic.attendance_by('groups', **filter_params)
  end

  def show
    @charts = {}
    @group = @subdepartment.groups.actual.find_by(:number => params[:id])

    @discipline = params[:discipline_id]
    @lecturer = params[:lecturer_id]

    if params.to_a[-2..-1][0][0] == 'discipline_id'
      @parent_url = subdepartment_lecturer_discipline_path(@lecturer, @discipline, :filter => params[:filter])
      group_statistic = Statistic::Lecturer.new("#{@lecturer}:#{@subdepartment}:#{@discipline}:#{@group}", nil)
    elsif params[:course_id]
      namespace = "#{current_namespace}/courses/#{params[:course_id]}/groups/#{@group}"
      @parent_url = subdepartment_course_path(params[:course_id], :filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, namespace)
    else
      namespace = "#{current_namespace}/groups/#{@group}"
      @parent_url = subdepartment_groups_path(:filter => params[:filter])
      group_statistic = Statistic::Group.new(@group, namespace)
    end



    @charts['attendance_by_dates.line']   = group_statistic.attendance_by_date(**filter_params)
    @charts['attendance_by_students.bar'] = group_statistic.attendance_by('students', **filter_params)
  end

  private

  def find_subdepartment
    @subdepartment = current_user.subdepartments.actual.first
  end
end
