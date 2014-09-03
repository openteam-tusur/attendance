class Lecturer < Person
  has_many :lecturer_declarations, :as => :declarator, :dependent => :destroy
  has_many :memberships,           :as => :person
  has_many :subdepartments,        :through => :memberships, :source => :participate, :source_type => 'Subdepartment'
  has_many :permissions,           :as => :context

  has_many :realizes,       :dependent => :destroy
  has_many :lessons,        :through => :realizes
  has_many :groups,         -> { uniq.order('groups.number') }, :through => :lessons

  def info
    "#{self.to_s} #{actual_subdepartment.abbr}"
  end

  def short_name
    "#{surname} #{name.first}. #{patronymic.first}."
  end

  def actual_subdepartment
    subdepartments.where(:memberships => { :deleted_at => nil }).first
  end

  def as_json(options)
    super(:only => :id).merge(:label => info, :value => info)
  end
end
