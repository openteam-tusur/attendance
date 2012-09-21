class CreateRealizes < ActiveRecord::Migration
  def change
    create_table :realizes do |t|
      t.references :lecturer
      t.references :lesson

      t.timestamps
    end
    add_index :realizes, :lecturer_id
    add_index :realizes, :lesson_id
  end
end
