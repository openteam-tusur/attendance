class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :type
      t.string :name
      t.string :surname
      t.string :patronymic
      t.integer :contingent_id
      t.integer :directory_id
      t.string :secure_id

      t.timestamps
    end
  end
end
