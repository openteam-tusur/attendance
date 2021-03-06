class CreateSubdepartments < ActiveRecord::Migration
  def change
    create_table :subdepartments do |t|
      t.string :title
      t.string :abbr
      t.references :faculty, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
