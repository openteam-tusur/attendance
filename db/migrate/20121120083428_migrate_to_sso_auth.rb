class MigrateToSsoAuth < ActiveRecord::Migration
  def up
    drop_table :contexts
    change_table :users do |t|
      t.remove  :nickname
      t.remove  :location
      t.remove  :description
      t.remove  :image
      t.remove  :phone
      t.remove  :urls
    end
  end

  def down
    create_table :contexts, :force => true do |t|
      t.string  :title
      t.string  :ancestry
      t.string  :weight
      t.timestamps
    end
    change_table :users do |t|
      t.column  :nickname,     :text
      t.column  :location,     :text
      t.column  :description,  :text
      t.column  :image,        :text
      t.column  :phone,        :text
      t.column  :urls,         :text
    end
  end
end
