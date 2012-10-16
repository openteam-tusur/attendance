# encoding: utf-8
require 'progress_bar'

desc 'Импорт пользователей в attendance'
task :import_tusur_group_leaders => :environment do
  yml_path = ENV['YML_PATH'] || "#{File.dirname(File.expand_path(__FILE__))}/group_leaders.yml"
  list = YAML.load_file(yml_path)
  list['group_leader'].each do |faculty, groups|
    bar = ProgressBar.new(groups.count)
    puts faculty
    groups.each do |group, student|
      if group_obj = Group.find_by_number(group.to_s)
        if (user = User.find_or_initialize_by_uid(student['uid'].to_s)).new_record?
          user.first_name = student['name']
          user.last_name = student['surname']
          user.name = "#{student['name']} #{student['patronymic']} #{student['surname']}"
          user.email = student['email']
          user.save!
          user.permissions << Permission.new(:context => group_obj, :role => :group_leader)
        end
      else
        puts "!!! #{group} не найдена !!!"
      end
      bar.increment!
    end
  end
end
