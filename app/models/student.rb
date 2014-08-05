class Student < Person
  has_many :memberships, :as => :person, :dependent => :destroy
  has_many :groups,      :through => :memberships, :source => :participate, :source_type => 'Group'

  has_many :presences,   :dependent => :destroy
  has_many :lessons,     :through => :presences

  has_many :misses,         :as => :missing, :dependent => :destroy

  before_create :set_secure_id

  scope :actual,      -> { where(:deleted_at => nil) }
  scope :not_actual,  -> { where.not(:deleted_at => nil) }

  def set_secure_id
    self.secure_id = Digest::MD5.hexdigest("#{self.to_s}#{self.contingent_id}")
  end
end
