class AddDeletedAtToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :deleted_at, :datetime
  end
end
