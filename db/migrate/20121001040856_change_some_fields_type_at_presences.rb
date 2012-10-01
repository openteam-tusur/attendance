require 'progress_bar'

class ChangeSomeFieldsTypeAtPresences < ActiveRecord::Migration
  def up
    change_column :presences, :date_on, :date
    change_column :lessons, :date_on, :date

    bar = ProgressBar.new(Lesson.count)
    Lesson.find_each do |lesson|
      lesson.update_attribute :date_on, lesson.date_on+1.day
      lesson.presences.update_all(:date_on => lesson.date_on)
      bar.increment!
    end
  end

  def down
    change_column :lessons, :date_on, :datetime
    change_column :presences, :date_on, :datetime
  end
end
