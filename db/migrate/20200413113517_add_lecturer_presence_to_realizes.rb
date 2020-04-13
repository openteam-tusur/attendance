class AddLecturerPresenceToRealizes < ActiveRecord::Migration
  def change
    add_column :realizes, :lecturer_presence, :boolean
  end
end
