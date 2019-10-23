namespace :delete do
  desc 'Удаление посещаемости для удаленных студентов'
  task presences_for_deleted_students: :environment do
    p "Проверка presence у всех удаленных студентов "
    deleted_students = Membership.students.where.not(deleted_at: nil)
    pb  = ProgressBar.new(deleted_students.count)
    deleted_students.each do |membership|
      membership.person.presences.joins(:lesson).where("lessons.date_on >= ? AND group_id = ?", membership.deleted_at.to_date, membership.participate).destroy_all if membership.person
      pb.increment!
    end
  end

  desc 'Удаление уроков без десциплины'
  task lessons_without_discipline: :environment do
    lessons_without_discipline = Lesson.
      where(discipline_id: nil).
      order(created_at: :desc)
    exit 0 if lessons_without_discipline.count == 0
    pb = ProgressBar.new(lessons_without_discipline.count)
    lessons_without_discipline.each do |lwd|
      lwd.destroy

      pb.increment!
    end
  end
end
