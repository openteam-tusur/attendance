class Declaration < ActiveRecord::Base
  belongs_to :realize
  belongs_to :declarator, polymorphic: true

  scope :for_declarator, ->(type) { where(:declarator_type => type) }

  validates_uniqueness_of :realize_id, :scope => [:declarator_id, :declarator_type], :message => 'Нельзя добавить еще одну объяснительную!'
  validates_presence_of :reason
end
