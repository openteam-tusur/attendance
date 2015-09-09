namespace :delete do
  desc 'Удаление посещаемости для удаленных студентов'
  task :presences_for_deleted_students => :environment do
    p "Удаление presence для deleted students"
    Membership.students.where.not(deleted_at: nil).each do |membership|
      membership.person.presences.joins(:lesson).where("lessons.date_on >= ? AND group_id = ?", membership.deleted_at.to_date, membership.participate).destroy_all if membership.person
    end
  end
end
