class LessonTime < Struct.new(:order, :date_on)
  def lesson_time
    date_on + start_time
  end

  #private

  def lesson_schedule
    lesson_hash = YAML.load_file('data/lessons.yml')

    lesson_hash[order.to_i]
  end

  def start_time
    lesson_schedule['hour'].hour + lesson_schedule['minutes'].minutes
  end
end
