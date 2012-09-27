# encoding: utf-8

class Presence < ActiveRecord::Base
  include Enumerize

  attr_accessible :kind, :lesson_id, :student_id

  belongs_to :lesson
  belongs_to :student

  before_save :set_date_on

  enumerize :kind, :in => [:not_marked, :was, :wasnt], :default => :not_marked, :predicates => true

  def to_s
    kind_text
  end

  private
    def set_date_on
      self.date_on = self.lesson.date_on
    end
end
