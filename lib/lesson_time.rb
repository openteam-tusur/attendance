class LessonTime < Struct.new(:order, :date_on, :training_shift)
  def lesson_time
    date_on + start_time
  end

  #private

  def lesson_schedule
    lesson_hash = YAML.load_file('data/lessons.yml')

    if training_shift.present?
      lesson_hash['training_shifts'][training_shift][order.to_i]
    else
      lesson_hash[order.to_i]
    end
  end

  def start_time
    lesson_schedule['hour'].hour + lesson_schedule['minutes'].minutes
  end
end
