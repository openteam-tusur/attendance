class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :classroom
      t.datetime :date_on
      t.string :kind
      t.string :order_number
      t.integer :timetable_id
      t.text :note
      t.references :discipline
      t.references :group

      t.timestamps
    end
    add_index :lessons, :discipline_id
    add_index :lessons, :group_id
  end
end
