class AddCreatorToPresences < ActiveRecord::Migration
  def change
    add_column :presences, :creator, :string
  end
end
