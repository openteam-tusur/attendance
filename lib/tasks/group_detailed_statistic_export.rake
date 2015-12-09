require "csv"
desc 'Помещает в /statistics csv с данными о посещаемости для выбранной группы в указанный период;
      аргументы передаются так:  rake detailed_statistic_for_group["363-1", "01.09.2015", "09.12.2015"]'
task :detailed_statistic_for_group, [:group_number, :start, :ends_at] => :environment do |t, args|

  group_number, start, ends_at = [:group_number, :start, :ends_at ].map do |arg|
    raise "#{arg} должен быть указан" if args[arg].blank?
    args[arg]
  end
  students = Group.find_by(number: group_number).students
  dates = Date.parse(start)..Date.parse(ends_at)
  CSV.open("statistic/#{group_number}-#{start}-#{ends_at}ends_at.csv", "w") do |csv|

    #собираем шапку файла
    head = ["Студент"]
    dates.each{|d| head << d.to_s }
    csv << head

    students.each do |s|
      row = []
      row << s.to_s
      statistics = Statistic::Student.new(s.contingent_id, nil)
      dates.each do |d|
        row << statistics.attendance_by_date(from: d, to: d).first.try(:last)
      end
      csv << row
    end

  end
end
