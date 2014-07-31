class CreateMisses < ActiveRecord::Migration
  def change
    create_table :misses do |t|
      t.integer   :missing_id
      t.string    :missing_type
      t.datetime  :starts_at
      t.datetime  :ends_at
      t.text :note

      t.timestamps
    end
    add_index :misses, [:missing_id, :missing_type]
  end
end
