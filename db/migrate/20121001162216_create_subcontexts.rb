class CreateSubcontexts < ActiveRecord::Migration
  def change
    create_table :subcontexts do |t|
      t.string :title
      t.references :context
      t.timestamps
    end
  end
end
