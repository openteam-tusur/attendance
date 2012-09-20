class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.string :kind
      t.references :lesson
      t.references :student

      t.timestamps
    end
    add_index :presences, :lesson_id
    add_index :presences, :student_id
  end
end
