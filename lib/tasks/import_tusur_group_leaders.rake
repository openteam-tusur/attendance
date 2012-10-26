# encoding: utf-8
require 'progress_bar'

desc 'Импорт пользователей в attendance'
task :import_tusur_group_leaders => :environment do
  yml_path = ENV['YML_PATH'] || "#{File.dirname(File.expand_path(__FILE__))}/group_leaders.yml"
  list = YAML.load_file(yml_path)
  list['group_leader'].each do |faculty, students|
    filtered_students = students.reject {|s| s['sended'] }
    next if filtered_students.empty?

    bar = ProgressBar.new(filtered_students.count)
    puts faculty
    current = nil

    begin
      User.transaction do
        filtered_students.each do |student|
          current = student
          group = Group.find_by_number(student['group'].to_s) || raise("Группа #{student['group']} не найдена !")
          if (user = User.find_or_initialize_by_uid(student['uid'].to_s)).new_record?
            user.first_name = student['name']
            user.last_name  = student['surname']
            user.name       = "#{student['name']} #{student['patronymic']} #{student['surname']}"
            user.email      = student['email']
            user.save!
            user.permissions.create! :context => group, :role => :group_leader
            bar.increment!
          end
        end
      end
    rescue => e
      puts
      puts
      user_name = "#{current['surname']} #{current['name']} (гр. #{current['group']}) <#{current['email']}>"
      divider = "-" * (user_name.length + 4)
      puts divider
      puts "| #{user_name} |"
      puts divider
      puts
      raise e
    end
  end
end
