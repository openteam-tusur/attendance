# encoding: utf-8
require 'progress_bar'

require File.expand_path '../import_tusur_users', __FILE__

def user_for(record)
  User.find_or_initialize_by_uid(record['uid'].to_s).tap do |user|
    user.first_name = record['name']
    user.last_name  = record['surname']
    user.name       = "#{record['name']} #{record['patronymic']} #{record['surname']}"
    user.email      = record['email']
    user.save!
  end
end

def process_student(record)
  user_for(record).permissions.create! :role    => :group_leader,
                                       :context => Group.find_by_number!(record['group'].to_s)
end

def process_dean(record)
  user_for(record).permissions.create! :role    => :faculty_worker,
                                       :context => Faculty.find_by_abbr!(record['faculty'].to_s)
end

def filtered_records
  records.reject{|r| r['sended']}
end

desc 'Импорт пользователей в attendance'
task :import_tusur_users => :environment do
  process
end
