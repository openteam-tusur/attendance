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
        lesson_time_start = LessonTime.new(lesson.order_number, lesson.date_on, lesson.training_shift).lesson_time - 10.minutes
        lesson_time_end = lesson_time_start + 95.minutes
        lecturer_presence_import(lesson, lesson_time_start.to_i, lesson_time_end.to_i)
        lesson.presences.each do |presence|
          next if presence.state.present?
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

  def lecturer_presence_import(lesson, lesson_time_start, lesson_time_end)
    lesson.realizes.each do |realize|
      lecturer_uid = realize.lecturer.user_id
      if lecturer_uid.present?
        statistic = MoodleApi.new().local_api_user_get_logs(lecturer_uid, lesson_time_start, lesson_time_end)
        if statistic[0]['status'] = 'done' && statistic[0]['logs'] != []
          realize.update(lecturer_presence: true)
        else
          realize.update(lecturer_presence: false)
        end
      else
        realize.update(lecturer_presence: false)
      end
    end
  end
end
