class Subdepartment < ActiveRecord::Base
  belongs_to  :faculty
  has_many    :subdepartment_declarations,  :as => :declarator, :class_name => 'SubdepartmentDeclaration', :dependent => :destroy
  has_many    :groups,                      :dependent => :destroy
  has_many    :permissions,                 :as => :context, :dependent => :destroy
  has_many    :memberships,                 :as => :participate,          :dependent => :destroy
  has_many    :lecturers,                   :through => :memberships, :source => :person, :source_type => 'Person', :class_name => 'Lecturer'
  has_many    :realizes,                    :through => :lecturers
  has_many    :presences,                   :through => :groups

  validates_uniqueness_of :title, :scope => :abbr
  normalize_attribute :title

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  def to_s
    abbr
  end
end

# == Schema Information
#
# Table name: subdepartments
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  faculty_id :integer
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#
