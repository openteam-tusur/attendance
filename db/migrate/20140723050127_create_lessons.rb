class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :group, index: true
      t.references :discipline, index: true
      t.string :classroom
      t.date :date_on
      t.string :kind
      t.string :order_number
      t.string :timetable_id
      t.date :deleted_at

      t.timestamps
    end
  end
end
