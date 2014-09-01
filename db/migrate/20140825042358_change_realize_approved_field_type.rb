class ChangeRealizeApprovedFieldType < ActiveRecord::Migration
  def up
    remove_column :realizes, :approved
    add_column :realizes, :approved, :string, :default => :unfilled
  end

  def down
    remove_column :realizes, :approved
    add_column :realizes, :approved, :boolean
  end
end
