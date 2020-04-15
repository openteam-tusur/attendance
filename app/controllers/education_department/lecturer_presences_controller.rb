class EducationDepartment::LecturerPresencesController < AuthController
  def index
    @dates = (Date.parse('2020-04-13')..Date.yesterday).to_a.reverse
  end
  def generate_xls
    report = Statistic::Xls::LecturerPresences.new(params[:date]).generate
    send_data report.to_stream.read,
      filename: "lecturer_presences-#{params[:date]}.xlsx",
      type: 'application/vnd.openxmlformates-officedocument.spreadsheetml.sheet'
  end
end
