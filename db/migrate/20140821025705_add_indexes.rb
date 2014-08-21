class AddIndexes < ActiveRecord::Migration
  def change
    add_index :lessons,         :deleted_at,        :where => "deleted_at IS NULL"
    add_index :presences,       :state,             :where => "state IS NOT NULL"
    add_index :realizes,        :state,             :where => "state = 'was'"
  end
end
