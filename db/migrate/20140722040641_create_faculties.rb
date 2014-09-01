class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :title
      t.string :abbr
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
