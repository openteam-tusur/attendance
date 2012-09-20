class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :classroom
      t.datetime :date_on
      t.string :kind
      t.string :order_number
      t.integer :timetable_id
      t.references :discipline
      t.references :group
      t.references :lecturer

      t.timestamps
    end
    add_index :lessons, :discipline_id
    add_index :lessons, :group_id
    add_index :lessons, :lecturer_id
  end
end
