# encoding: utf-8

class Lecturer < Person
  has_many :realizes
  has_many :lessons, :through => :realizes
  has_many :groups, :through => :lessons

  def to_s
    res = []
    res << surname
    res << "#{name[0]}." if name?
    res << "#{patronymic[0]}." if patronymic?
    res.join(' ')
  end

  def losed_lessons
    lessons.where("lessons.state = 'wasnt_took_place' AND lessons.date_on BETWEEN ? AND ?", Presence.last_week_begin, Presence.last_week_end)
  end
end
