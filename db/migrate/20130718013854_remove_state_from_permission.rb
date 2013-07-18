class RemoveStateFromPermission < ActiveRecord::Migration
  def up
    remove_column :permissions, :state
  end

  def down
    add_column :permissions, :state, :string
  end
end
