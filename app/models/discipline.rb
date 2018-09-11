class Discipline < ActiveRecord::Base
  has_many :permissions, :as => :context, :dependent => :destroy
  has_many :lessons,     :dependent => :destroy
  has_many :groups,      -> { uniq.order('groups.number') }, :through => :lessons
  has_many :lecturers,   -> { uniq.order('people.surname') }, :through => :lessons

  validates_uniqueness_of :title, :scope => [:abbr]
  normalize_attributes :title, :abbr

  def to_s
    title
  end
end

# == Schema Information
#
# Table name: disciplines
#
#  id         :integer          not null, primary key
#  abbr       :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
