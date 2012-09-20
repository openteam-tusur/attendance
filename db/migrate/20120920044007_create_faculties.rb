class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.text :title
      t.string :abbr

      t.timestamps
    end
  end
end
