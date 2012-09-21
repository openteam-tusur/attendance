# encoding: utf-8

class Lesson < ActiveRecord::Base
  include Enumerize

  attr_accessible :classroom, :date_on, :kind, :order_number, :timetable_id

  belongs_to :discipline
  belongs_to :group
  belongs_to :lecturer
  has_many :realizes
  has_many :presences
  has_many :lecturers, :through => :realizes

  enumerize :kind, :in => [:lecture, :practice, :laboratory, :research, :design]

  scope :by_group_and_date, ->(group, date){ get_lessons_at(group, date) }

  def self.get_lessons_at(group, date)
    collection = Group.find_by_number(group).lessons.any? ? Group.find_by_number(group).lessons : nil
    collection ||= getted_lessons(group, date)
    Lesson.where(:id => collection.map(&:id))
  end

  def self.getted_lessons(group, date)
    response = JSON.parse(Curl.get("#{Settings['timetable.url']}/api/v1/timetables/#{group}/#{date}").body_str)
    lessons = []
    response['lessons'].each do |lesson|
      discipline = Discipline.find_or_create_by_abbr_and_title(lesson['discipline'])
      lesson_obj = discipline.lessons.find_or_initialize_by_timetable_id(lesson['timetable_id']).tap do |item|
        item.classroom    = lesson['classroom']
        item.date_on      = Time.zone.parse(date)
        item.kind         = lesson['kind']
        item.order_number = lesson['order_number']
        item.note         = lesson['note']
        item.group_id     = Group.find_by_number(group).id
        item.save!
      end

      lesson['lecturers'].each do |lecturer|
        lecturer_obj = Lecturer.find_or_create_by_surname_and_name_and_patronymic(
          :surname => lecturer['lastname'],
          :name => lecturer['firstname'],
          :patronymic => lecturer['middlename']
        )

        Realize.find_or_create_by_lecturer_id_and_lesson_id(:lecturer_id => lecturer_obj.id, :lesson_id => lesson_obj.id)
      end

      lessons << lesson_obj
    end
    lessons
  end
end
