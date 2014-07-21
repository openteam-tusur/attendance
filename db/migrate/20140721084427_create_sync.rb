class CreateSync < ActiveRecord::Migration
  def change
    create_table :syncs do |t|
      t.string :state
      t.string :title

      t.timestamps
    end
  end
end
