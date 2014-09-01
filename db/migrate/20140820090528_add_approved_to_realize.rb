class AddApprovedToRealize < ActiveRecord::Migration
  def change
    add_column :realizes, :approved, :boolean
  end
end
