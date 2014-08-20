class Declaration < ActiveRecord::Base
  belongs_to :realize
  belongs_to :declarator, polymorphic: true

  scope :for_declarator, ->(type) { where(:declarator_type => type) }
end
