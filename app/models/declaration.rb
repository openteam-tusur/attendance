class Declaration < ActiveRecord::Base
  belongs_to :realize
  belongs_to :declarator, polymorphic: true

  scope :for_declarator, ->(type) { where(:declarator_type => type) }

  validates_uniqueness_of :realize_id, :scope => [:declarator_id, :declarator_type], :message => 'Нельзя добавить еще одну объяснительную!'
  validates_presence_of :reason
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
