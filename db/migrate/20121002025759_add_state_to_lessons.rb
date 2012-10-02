class AddStateToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :state, :string
  end
end
