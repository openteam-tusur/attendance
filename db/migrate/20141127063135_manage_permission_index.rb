class ManagePermissionIndex < ActiveRecord::Migration
  def change
    remove_index :permissions, name: "by_email_context_role"
    remove_index :permissions, name: "by_user_and_role_and_context"

    add_index    :permissions, [:user_id, :email, :context_id, :context_type, :role], :unique => true, :using => :btree, :name => 'by_user_email_context_role'
  end
end
