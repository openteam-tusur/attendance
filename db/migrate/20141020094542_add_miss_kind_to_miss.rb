class AddMissKindToMiss < ActiveRecord::Migration
  def change
    add_column :misses, :miss_kind_id, :integer
  end
end
