class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.references :student, index: true
      t.references :lesson, index: true
      t.string :state

      t.timestamps
    end
  end
end
