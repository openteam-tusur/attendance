class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :surname
      t.string :name
      t.string :patronymic
      t.string :type
      t.integer :contingent_id
      t.references :group

      t.timestamps
    end
    add_index :people, :group_id
  end
end
