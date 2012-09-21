# encoding: utf-8

class Group < ActiveRecord::Base
  attr_accessible :course, :number

  belongs_to :faculty
  has_many :students
  has_many :lessons

  default_scope order('number')

  def to_s
    "гр. #{number}"
  end

  def to_param
    number
  end
end
