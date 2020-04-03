require 'progress_bar'
class PresenceCatcher
  attr_accessor :groups, :lesson_date

  def initialize(groups, lesson_date)
    self.groups = groups
    self.lesson_date = lesson_date
  end

  def sync
    pb = ProgressBar.new(groups.count)
    groups.find_each do |group|
      group.lessons.by_date(lesson_date).order('order_number').each do |lesson|
        lesson_time_start = LessonTime.new(lesson.order_number, lesson.date_on).lesson_time
        lesson_time_end = lesson_time_start + 95.minutes
        lesson.presences.each do |presence|
          uid = presence.student.user_id
          if uid.present?
            statistic = MoodleApi.new().local_api_user_get_logs(uid, lesson_time_start.to_i, lesson_time_end.to_i)
            if statistic[0]['status'] = 'done' && statistic[0]['logs'] != []
              presence.update_attributes(state: 'was', creator: 'sdo')
            else
              presence.update_attributes(:state => 'wasnt', creator: 'sdo')
            end
          else
            presence.update_attributes(:state => 'wasnt', creator: 'sdo')
          end
        end
      end
      pb.increment!
    end
  end
end
