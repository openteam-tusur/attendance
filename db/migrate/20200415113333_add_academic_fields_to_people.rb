class AddAcademicFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :academic_rank, :string
    add_column :people, :academic_degree, :string
  end
end
