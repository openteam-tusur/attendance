class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :number
      t.integer :course
      t.references :subdepartment, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
