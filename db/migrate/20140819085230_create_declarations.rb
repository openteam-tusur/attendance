class CreateDeclarations < ActiveRecord::Migration
  def change
    create_table :declarations do |t|
      t.references :realize, index: true
      t.references :declarator, polymorphic: true, index: true
      t.text :reason
      t.string :type

      t.timestamps
    end
  end
end
