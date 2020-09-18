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
      proxy_association.owner.presences.each {|p| p.update_attributes(:state => nil) }
      self.update_all(:state => new_state)
      self.index
    end
  end

  has_many   :lecturers,  :through    => :realizes

  scope :by_date,       ->(date)     { where(:date_on => date) }
  scope :actual,        ->           { where(:deleted_at => nil) }
  scope :not_actual,    ->           { where.not(:deleted_at => nil) }
  scope :unfilled,      ->           { joins(:presences).where(:presences => { :state => nil }).uniq }
  scope :filled,        ->           { joins(:presences).where.not(:presences => { :state => nil }).uniq }
  scope :by_semester,   ->           { where('date_on > :start_at and date_on < :end_at', :start_at => semester_begin, :end_at => last_day_needed_to_fill)}
  scope :realized,      ->           { joins(:realizes).where(:realizes => { :state => :was }).uniq }
  scope :between_dates, ->(from, to) { where('date_on between :from and :to', :from => from, :to => to) }

  delegate :faculty, :training_shift, to: :group

  def realized?
    realizes.select(:state).first.state == 'was'
  end

  def actual?
    deleted_at.nil?
  end

  def lesson_time
    LessonTime.new(self.order_number, self.date_on, training_shift).lesson_time
  end

  def lesson_lecturers
    lecturers.map(&:short_name).join(', ')
  end

  def kind_abbr
    I18n.t("lesson.kind.#{kind}.abbr")
  end
end

# == Schema Information
#
# Table name: lessons
#
#  id                :integer          not null, primary key
#  group_id          :integer
#  discipline_id     :integer
#  classroom         :string(255)
#  date_on           :date
#  kind              :string(255)
#  order_number      :string(255)
#  timetable_id      :string(255)
#  deleted_at        :date
#  created_at        :datetime
#  updated_at        :datetime
#  edu_discipline_id :string
#  moodle_id         :integer
#
