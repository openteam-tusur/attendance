class Person < ActiveRecord::Base
  validates_uniqueness_of :contingent_id, :directory_id, :secure_id, :allow_nil => true
  validates_presence_of   :name, :surname
  normalize_attributes    :name, :surname, :patronymic

  def to_s
    [surname, name, patronymic].map(&:presence).compact.join(' ')
  end
end

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  name            :string(255)
#  surname         :string(255)
#  patronymic      :string(255)
#  contingent_id   :integer
#  directory_id    :integer
#  secure_id       :string(255)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :string
#  academic_rank   :string
#  academic_degree :string
#
