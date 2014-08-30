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
        add_permission('student', json)
      when /:profile:del_student:/
        del_permission('student', json)
      when /:timetable:add_permission/
        add_permission('lecturer', json)
      when /:timetable:del_permission/
        del_permission('lecturer', json)
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

  def add_permission(context, json)
    user = find_user(json['uid'])
    person = send("find_#{context}", json[remote_key(context)])

    begin
      if user
        user.permissions.find_or_create_by(:role => context, :context_id => person.id, :context_type => 'Person')
      else
        Pemission.find_or_create_by(:role => context, :context_id => person.id, :context_type => 'Person', :email => json['email'])
      end
    rescue ActiveRecord::RecordNotUnique
    end if person
  end

  def del_permission(context, json)
    user = find_user(json['uid'])
    person = send("find_#{context}", json[remote_key(context)])

    permission = if user
                   user.permissions.find_by(:role => context, :context_id => person.id, :context_type => 'Person') if person
                 else
                   Permission.find_by(:role => context, :context_id => person.id, :context_type => 'Person', :email => json['email']) if person
                 end
    permission.destroy if permission
  end

  def remote_key(context)
    case context
    when 'student'
      'contingent_id'
    when 'lecturer'
      'directory_id'
    end
  end

  def find_user(uid)
    User.find_by(:uid => uid)
  end

  def find_lecturer(directory_id)
    return nil unless directory_id.present?
    Lecturer.find_by(:directory_id => directory_id)
  end

  def find_student(contingent_id)
    return nil unless contingent_id.present?
    Student.find_by(:contingent_id => contingent_id)
  end
end
