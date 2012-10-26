# encoding: utf-8

def yml_path
  @yml_path ||= File.expand_path('../../../config/users.yml', __FILE__)
end

def yaml
  @yaml ||= YAML.load_file(yml_path)
end

def write_yaml
  File.open(yml_path, "w"){ |f| f.write yaml.to_yaml }
end

def process(records, options={}, &block)
  current = nil
  bar = ProgressBar.new(records.count)
  begin
    User.transaction do
      records.each do |record|
        current = record
        block.call(record)
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

