class AddMoodleFieldsToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :edu_discipline_id, :string
    add_column :lessons, :moodle_id, :integer
  end
end
