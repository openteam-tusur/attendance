# encoding: utf-8

class Discipline < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :lessons, :dependent => :destroy

  def to_s
    title
  end
end
