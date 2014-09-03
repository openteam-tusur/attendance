require 'lesson_time'

class Lesson < ActiveRecord::Base
  extend DateRange

  belongs_to :group
  belongs_to :discipline
  has_many   :presences,  :dependent  => :destroy
  has_many   :students,   :through    => :presences

  has_many   :realizes,   :dependent  => :destroy do
    def change_state
      new_state = proxy_association.owner.realized? ? :wasnt : :was
      self.update_all(:state => new_state)
      self.index
    end
  end

  has_many   :lecturers,  :through    => :realizes

  scope :by_date,     ->(date) { where(:date_on => date) }
  scope :actual,      ->       { where(:deleted_at => nil) }
  scope :not_actual,  ->       { where.not(:deleted_at => nil) }
  scope :unfilled,    ->       { joins(:presences).where(:presences => { :state => nil }).uniq }
  scope :filled,      ->       { joins(:presences).where.not(:presences => { :state => nil }).uniq }
  scope :by_semester, ->       { where('date_on > :start_at and date_on < :end_at', :start_at => semester_begin, :end_at => last_week_end)}
  scope :realized,    ->       { joins(:realizes).where(:realizes => { :state => :was }).uniq }

  def realized?
    realizes.select(:state).first.state == 'was'
  end

  def actual?
    deleted_at.nil?
  end

  def lesson_time
    LessonTime.new(self.order_number, self.date_on).lesson_time
  end

  def lesson_lecturers
    lecturers.map(&:short_name).join(', ')
  end

  def kind_abbr
    I18n.t("lesson.kind.#{kind}.abbr")
  end
end
