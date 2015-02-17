class Person < ActiveRecord::Base
  validates_uniqueness_of :contingent_id, :directory_id, :secure_id, :allow_nil => true
  validates_presence_of   :name, :surname
  normalize_attributes    :name, :surname, :patronymic

  def to_s
    [surname, name, patronymic].map(&:presence).compact.join(' ')
  end
end
