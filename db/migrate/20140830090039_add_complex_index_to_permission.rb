class AddComplexIndexToPermission < ActiveRecord::Migration
  def change
    add_index :permissions, [:email, :context_id, :context_type, :role], :unique => true, :name => 'by_email_context_role'
  end
end
