class CreateMissKinds < ActiveRecord::Migration
  def change
    create_table :miss_kinds do |t|
      t.string :kind

      t.timestamps
    end
  end
end
