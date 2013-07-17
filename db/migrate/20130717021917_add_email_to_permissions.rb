class AddEmailToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :email, :string

    Permission.find_each { |permission| permission.update_attribute :email, permission.user.email }
  end
end
