class Faculty < ActiveRecord::Base
  has_many :permissions,    :as => :context, :dependent => :destroy
  has_many :subdepartments, :dependent => :destroy
  has_many :lecturers,      :through => :subdepartments
  has_many :realizes,       :through => :lecturers
  has_many :groups,         :through => :subdepartments
  has_many :presences,      :through => :groups
  has_many :students,       :through => :groups
  has_many :misses,         :through => :students

  validates_uniqueness_of :title, :scope => :abbr
  normalize_attribute :title

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }
  scope :without_untracked, -> {
    where.not(
      title: [
        'Аспирантура',
        'Заочный и вечерний факультет',
        'Институт инноватики',
        'Факультет дистанционного обучения',
      ]
    )
  }

  def to_s
    abbr
  end

  def transliterated_abbr
    Russian.transliterate(abbr).downcase rescue ''
  end
end

# == Schema Information
#
# Table name: faculties
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#
