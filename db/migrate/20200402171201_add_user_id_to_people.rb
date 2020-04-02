class AddUserIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :user_id, :string
  end
end
