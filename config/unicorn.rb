require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

def dir.settings
  heroku? ? {} : (YAML.load_file(config('settings.yml'))['unicorn'] || {})
end
def dir.old_pid
  "#{pid_file}.oldbin"
end


worker_processes  (dir.settings['workers'] || ENV['UNICORN_WORKERS'] || 2).to_i
timeout           (dir.settings['timeout'] || ENV['UNICORN_TIMEOUT'] || 300).to_i
preload_app       true
pid               dir.pid_file

listen            ENV['PORT'].to_i, :tcp_nopush => false if ENV['PORT'].to_i > 0

unless dir.heroku?
  listen            "/tmp/#{dir.group}-#{dir.project}.sock", :backlog => 64

  stdout_path       dir.log('stdout.log')
  stderr_path       dir.log('stderr.log')
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  if File.exists?(dir.old_pid) && server.pid != dir.old_pid
    begin
      Process.kill("QUIT", File.read(dir.old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
