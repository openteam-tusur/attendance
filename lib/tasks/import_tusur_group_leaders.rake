# encoding: utf-8
require 'progress_bar'

desc 'Импорт пользователей в attendance'
task :import_tusur_group_leaders => :environment do
  yml_path = ENV['YML_PATH'] || "#{File.dirname(File.expand_path(__FILE__))}/group_leaders.yml"
  list = YAML.load_file(yml_path)
  list['group_leader'].each do |faculty, groups|
    bar = ProgressBar.new(groups.count)
    puts faculty
    record = nil
    begin
      User.transaction do
        groups.each do |group_number, student|
          record = student
          group = Group.find_by_number(group_number.to_s) || raise("Группа #{group_number} не найдена !")
          if (user = User.find_or_initialize_by_uid(student['uid'].to_s)).new_record?
            user.first_name = student['name']
            user.last_name  = student['surname']
            user.name       = "#{student['name']} #{student['patronymic']} #{student['surname']}"
            user.email      = student['email']
            user.save!
            user.permissions.create! :context => group, :role => :group_leader
          end
          bar.increment!
        end
      end
    rescue => e
      puts
      puts
      user_name = "#{record['surname']} #{record['name']} <#{record['email']}>"
      divider = "-" * (user_name.length + 4)
      puts divider
      puts "| #{user_name} |"
      puts divider
      puts
      raise e
    end
  end
end
