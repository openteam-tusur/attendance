namespace :statistic do
  desc 'Подсчет статистки для студентов'
  task :students => :environment do
    Student.actual.each do |student|
      presences = student.presences
        .joins(:lesson   => :realizes)
        .where(:lessons  => { :deleted_at => nil })
        .where(:realizes => { :state => 'was' })
        .where.not(:presences => { :state => nil })
      Statistic::Student.new(student).calculate_attendance(presences)
    end
  end

  desc 'Подсчет статистки для групп'
  task :groups => :environment do
    Group.actual.each do |group|
      presences = group.presences
        .joins(:lesson   => :realizes)
        .where(:lessons  => { :deleted_at => nil })
        .where(:realizes => { :state => 'was' })
        .where.not(:presences => { :state => nil })
      Statistic::Group.new(group).calculate_attendance(presences)
    end
  end
end
