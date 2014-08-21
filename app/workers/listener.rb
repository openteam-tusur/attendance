require 'json'
require 'redis'

class Listener
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely.second_of_minute(0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57) }

  def perform
    redis = Redis.new(:url => Settings['messaging.url'])

    keys = redis.keys "attendance:*"

    keys.each do |key|
      next if key =~ /:index/
      info = redis.get(key)
      next unless info.present?
      next if info.length < 2
      json = JSON.parse(info)

      case key
      when /:sso:signin:/
        create_user_by(json)
      when /:profile:add_student:/
        add_student_permission(json)
      when /:profile:del_student:/
        del_student_permission(json)
      end

      redis.del(key)
    end
  end

  private

  def create_user_by(json)
    begin
      user = User.find_or_create_by json
    rescue ActiveRecord::RecordNotUnique
    end
  end

  def add_student_permission(json)
    user = User.find_by(:uid => json['uid'])
    student = Student.find_by(:contingent_id => json['contingent_id'])
    begin
      user.permissions.find_or_create_by(:role => :student, :context_id => student.id, :context_type => 'Person')
    rescue ActiveRecord::RecordNotUnique
    end if user && student
  end

  def del_student_permission(json)
    user = User.find_by(:uid => json['uid'])
    student = Student.find_by(:contingent_id => json['contingent_id'])
    permission = user.permissions.find_by(:role => :student, :context_id => student.id, :context_type => 'Person') if user && student
    permission.destroy if permission
  end
end
