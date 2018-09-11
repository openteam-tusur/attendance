class Student < Person
  include DateRange

  has_many :memberships, :as => :person, :dependent => :destroy
  has_many :groups,      ->{ where(:memberships => { :deleted_at => nil }) }, :through => :memberships, :source => :participate, :source_type => 'Group'

  has_many :presences,   :dependent => :destroy
  has_many :lessons,     :through => :presences
  has_many :disciplines, -> { uniq.order('disciplines.title') }, :through => :lessons
  has_many :permissions,           :as => :context

  has_many :misses,      -> { where(:missing_type => 'Student') }, :class_name => 'Miss', :foreign_key => :missing_id, :dependent => :destroy

  before_create :set_secure_id

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  searchable :auto_index => false do
    string(:info)
    integer(:faculty_id) { actual_group.try(:subdepartment).try(:faculty_id) }
    string :deleted_at
  end

  def slacker?(from: nil, to: nil)
    v = total_attendance(from, to)
    if v.nil?
      return false
    else
     v < 80
    end
  end

  def total_attendance(from, to)
    res = Statistic::Student.new(contingent_id, nil).attendance_by_date(from: from, to: to).inject({:sum => 0, :count => 0}) { |s, (_, item)| s[:sum] += item; s[:count] += 1; s }
    res[:count] > 0 ? (res[:sum]/res[:count]).round(1) : nil
  end

  def info
    "#{self.surname} #{self.name} #{actual_group.try(:number)}"
  end

  def as_json(options)
    super(:only => :id).merge(:label => info, :value => info)
  end

  def actual?
    deleted_at.nil?
  end

  def actual_group
    groups.where(:memberships => { :deleted_at => nil }).first
  end

  def set_secure_id
    self.secure_id = Digest::MD5.hexdigest("#{self.to_s}#{self.contingent_id}")
  end
end

# == Schema Information
#
# Table name: people
#
#  id            :integer          not null, primary key
#  type          :string(255)
#  name          :string(255)
#  surname       :string(255)
#  patronymic    :string(255)
#  contingent_id :integer
#  directory_id  :integer
#  secure_id     :string(255)
#  deleted_at    :datetime
#  created_at    :datetime
#  updated_at    :datetime
#
