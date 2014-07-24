class CreateMisses < ActiveRecord::Migration
  def change
    create_table :misses do |t|
      t.integer   :person_id
      t.datetime  :starts_at
      t.datetime  :ends_at
      t.text :note

      t.timestamps
    end
    add_index :misses, :person_id
  end
end
