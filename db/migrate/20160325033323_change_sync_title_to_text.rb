class ChangeSyncTitleToText < ActiveRecord::Migration
  def change
    change_table :syncs do |t|
      t.change :title, :text
    end
  end
end
