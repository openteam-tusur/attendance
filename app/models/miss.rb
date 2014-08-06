class Miss < ActiveRecord::Base
  attr_accessor :name

  belongs_to :missing, :polymorphic => true

  scope :for_student, ->(_) { where(:missing_type => 'Student') }
end
