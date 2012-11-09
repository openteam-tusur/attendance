namespace :deploy do
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/manage/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("./app/views/layouts/maintenance.html.erb")
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/manage/maintenance.html", :mode => 0644
    end

    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm -f #{shared_path}/system/manage/maintenance.html"
    end
  end
end
