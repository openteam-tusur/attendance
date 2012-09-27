# encoding: utf-8

class Faculty < ActiveRecord::Base
  attr_accessible :abbr, :title

  has_many :groups

  def to_s
    "#{title}(#{abbr})"
  end

  def to_param
    abbr
  end
end
