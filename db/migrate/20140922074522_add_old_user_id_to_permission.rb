class AddOldUserIdToPermission < ActiveRecord::Migration
  def up
    add_column :permissions, :old_user_uid, :integer
    add_column :permissions, :old_user_id, :integer

    Permission.where.not(:user_id => nil).each do |perm|
      user = User.find(perm.user_id)

      perm.update_column(:old_user_uid, user.uid)
      perm.update_column(:old_user_id, perm.user_id)
    end

    Permission.update_all(:user_id => nil)

    change_column :permissions, :user_id, :string
  end

  def down
    Permission.update_all(:user_id => nil)

    change_column :permissions, :user_id, :integer

    Permission.find_each do |perm|
      perm.update_column(:user_id, perm.old_user_id)
    end

    remove_column :permissions, :old_user_id
  end
end
