class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :context, :polymorphic => true
      t.string :role
      t.string :email
      t.timestamps
    end
    add_index :permissions, [:user_id, :role, :context_id, :context_type], :name => 'by_user_and_role_and_context', :unique => true

    User.find_or_initialize_by_uid('1').tap do | user |
      user.save(:validate => false)
      user.permissions.create! :role => 'administrator' if user.permissions.empty?
    end
  end
end
