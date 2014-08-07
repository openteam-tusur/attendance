class Lecturer < Person
  has_many :memberships,    :as => :person, :dependent => :destroy
  has_many :subdepartments, :through => :memberships, :source => :participate, :source_type => 'Subdepartment'

  has_many :realizes,       :dependent => :destroy
  has_many :lessons,        :through => :realizes
  has_many :groups,         -> { uniq.order('groups.number') }, :through => :lessons

  has_many :misses,         -> { where(:missing_type => 'Lecturer') }, :class_name => 'Miss', :foreign_key => :missing_id, :dependent => :destroy

  searchable do
    string :info
    string :deleted_at
  end

  def info
    "#{self.to_s} #{actual_subdepartment.abbr}"
  end

  def actual_subdepartment
    subdepartments.where(:memberships => { :deleted_at => nil }).first
  end

  def as_json(options)
    super(:only => :id).merge(:label => info, :value => info)
  end
end
