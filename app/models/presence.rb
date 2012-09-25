# encoding: utf-8

class Presence < ActiveRecord::Base
  include Enumerize

  attr_accessible :kind, :lesson_id, :student_id

  belongs_to :lesson
  belongs_to :student

  enumerize :kind, :in => [:not_marked, :was, :wasnt], :default => :not_marked, :predicates => true

  def to_s
    kind_text
  end
end
