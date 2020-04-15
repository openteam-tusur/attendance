class Statistic::Xls::LecturerPresences
  attr_accessor :ws, :wb, :style, :report, :common_styles

  def initialize(report_date)
    @report_date = report_date
    @report = Axlsx::Package.new
    @lessons = Lesson.by_date(Date.parse(@report_date))
  end

  def header
    [
      "Кафедра",
      "ФИО преподавателя",
      "Дисциплина",
      "Группа",
      "Время занятия по расписанию",
      "Присутствие"
    ]
  end


  def generate
    report.use_shared_strings = true
    @wb = report.workbook
    @ws = wb.add_worksheet(name: 'Посещаемость ППС за' + @report_date)
    set_header
    set_data
    serialize_report
    @report
  end

  def set_header
    @common_styles = {
      alignment: {
        horizontal: :left,
        wrap_text: true,
        vertical: :top
      },
      border: {
        style: :thin,
        color: '00'
      },
      b: true,
    }

    wb.styles { |s| @style = s.add_style common_styles }
    ws.add_row header, style: [@style] * header.count
  end

  def set_data
    common_styles.merge!(b: false)
    wb.styles { |s| @style = s.add_style common_styles }
    @lessons.each do |lesson|
      lesson.realizes.each do |realize|
        data = [
          realize.lecturer.subdepartments.try(:map) {|s| s['title']}.uniq.join(', '),
          realize.lecturer.short_name,
          lesson.discipline.title,
          lesson.group.number,
          I18n.t("lesson.time.#{lesson.order_number}"),
          realize.lecturer_presence
        ]
        ws.add_row data, style: [@style] * data.count
        ws.column_widths *[50, 50, 80, 30, 30, 30]
      end
    end
  end

  def serialize_report
    report.serialize(Rails.root.join(%(lecturer_presences.xlsx)))
  end
end
