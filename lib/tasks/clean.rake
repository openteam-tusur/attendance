# encoding: utf-8

desc 'Очистка от дублей'
task :clean => :environment do
  Lesson.pluck(:date_on).uniq.sort.each_with_index do |date_on, index|
    puts ''
    puts ''
    puts "***"*10
    puts "Дата #{date_on}"
    (1..7).each do |order_number|
      puts ""
      puts "#{order_number} пара"
      Lesson.where(:date_on => date_on, :order_number => order_number.to_s).group_by(&:group_id).each do |group_id, lessons|
        if lessons.count > 1
          puts "Группа #{Group.find(group_id).number}"
          lessons.each do |lesson|
            puts "#{lesson.classroom} - #{lesson.discipline.title}"
          end

          (lessons - [lessons.first]).map(&:destroy)
          puts "---"*10
        end
      end
    end
  end
end

desc "Удалить указанные дни DAYS='%Y-%m-%d, ...'"
task :remove => :environment do
  if ENV['DAYS'].present?
    ENV['DAYS'].split(',').each do |date|
      if (lessons = Lesson.where(:date_on => Time.zone.parse(date).to_date)).any?
        puts "Удаляются уроки за #{date}"
        lessons.destroy_all
      end
    end
  else
    puts 'Не указал дни ;('
  end
end
