class Membership < ActiveRecord::Base
  belongs_to :participate,  :polymorphic => true
  belongs_to :lecturer,     :class_name => 'Lecturer', :foreign_key => :person_id, :foreign_type => :person_type
  belongs_to :student,      :class_name => 'Student',  :foreign_key => :person_id, :foreign_type => :person_type
end
