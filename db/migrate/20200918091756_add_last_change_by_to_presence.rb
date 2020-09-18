class AddLastChangeByToPresence < ActiveRecord::Migration
  def change
    add_column :presences, :last_change_by, :string
  end
end
