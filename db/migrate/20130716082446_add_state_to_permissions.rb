class AddStateToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :state, :string

    Permission.update_all :state => :active
  end
end
