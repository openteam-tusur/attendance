class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string  :participate_type
      t.integer :participate_id

      t.string  :person_type
      t.integer :person_id

      t.datetime :deleted_at

      t.timestamps
    end

    add_index :memberships, [:participate_id, :participate_type]
    add_index :memberships, [:person_id, :person_type]
  end
end
