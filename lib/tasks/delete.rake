namespace :delete do
  desc 'Удаление посещаемости для удаленных студентов'
  task :presences_for_deleted_students => :environment do
    p "Удаление presence для deleted students"
    Student.where.not(deleted_at: nil).each do |s|
      s.presences.joins(:lesson).where("lessons.date_on >= ?", s.deleted_at.to_date).destroy_all
    end
  end
end
