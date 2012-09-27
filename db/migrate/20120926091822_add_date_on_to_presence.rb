class AddDateOnToPresence < ActiveRecord::Migration
  def change
    add_column :presences, :date_on, :datetime
  end
end
