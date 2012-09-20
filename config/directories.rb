class Directories
  def root
    @root ||= File.expand_path('../..', __FILE__)
  end

  def group
    @group ||= root.split('/')[-2]
  end

  def project
    @project ||= root.split('/')[-1]
  end

  def config(file=nil)
    "#{root}/config/#{file}"
  end

  def log_dir
    @log_dir ||= FileUtils.mkdir_p("/var/log/#{group}/#{project}").first rescue "#{root}/log"
  end

  def log(file=nil)
    "#{log_dir}/#{file}"
  end

  def pid_file
    @pid_file ||= begin
                    FileUtils.mkdir_p("/var/run/#{group}")
                    "/var/run/#{group}/#{project}.pid"
                  rescue Errno::EACCES
                    "/tmp/#{group}-#{project}.pid"
                  end
  end

  def heroku?
    ENV['PORT']
  end

end
