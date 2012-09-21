# encoding: utf-8

class Lecturer < Person
  has_many :realizes
  has_many :lessons, :through => :realizes
end
