# encoding: utf-8

class Person < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname
  normalize_attributes :name, :patronymic, :surname, :with => [:strip, :blank], :after => [:strip, :blank] do |value|
    value.present? && value.is_a?(String) ? value.mb_chars.titleize.gsub(/\./, '') : value
  end

  def to_s
    "#{surname} #{name} #{patronymic}"
  end
end
