class SubdepartmentDeclaration < Declaration
end

# == Schema Information
#
# Table name: declarations
#
#  id              :integer          not null, primary key
#  realize_id      :integer
#  declarator_id   :integer
#  declarator_type :string(255)
#  reason          :text
#  type            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
