class CreateRealizes < ActiveRecord::Migration
  def change
    create_table :realizes do |t|
      t.references :lecturer, index: true
      t.references :lesson, index: true
      t.string :state

      t.timestamps
    end
  end
end
