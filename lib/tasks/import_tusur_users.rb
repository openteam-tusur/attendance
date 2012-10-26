# encoding: utf-8

def yml_path
  @yml_path ||= File.expand_path('../../../config/users.yml', __FILE__)
end

def yaml
  @yaml ||= YAML.load_file(yml_path)
end

def records
  @records ||= yaml.values.flatten
end

def write_yaml
  File.open(yml_path, "w"){ |f| f.write yaml.to_yaml }
end

def filtered_records
  @filtered_records ||= records.select{|r| filter(r)}
end

def process
  current = nil
  bar = ProgressBar.new(filtered_records.count)
  begin
    User.transaction do
      filtered_records.each do |record|
        current = record
        if record['group']
          process_student(record)
        elsif record['faculty']
          process_dean(record)
        else
          raise 'неизвестный тип записи'
        end
        bar.increment!
      end
    end
  rescue => e
    user = "#{current['surname']} #{current['name']} (гр. #{current['group']}) <#{current['email']}>"
    divider = "-" * (user.length + 4)
    puts "\n#{divider}\n| #{user} |\n#{divider}\n"
    raise e
  end
  write_yaml
end

