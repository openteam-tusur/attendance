class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :number
      t.integer :course
      t.references :faculty

      t.timestamps
    end
    add_index :groups, :faculty_id
  end
end
