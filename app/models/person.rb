class Person < ActiveRecord::Base
  attr_accessible :name, :patronymic, :surname
end
