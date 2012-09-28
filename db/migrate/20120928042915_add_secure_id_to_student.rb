class AddSecureIdToStudent < ActiveRecord::Migration
  def change
    add_column :people, :secure_id, :string
  end
end
