# encoding: utf-8

class Person < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname

  default_scope order(:surname)

  def fio
    "#{surname} #{name} #{patronymic}".squish
  end

  def to_s
    fio
  end
end
