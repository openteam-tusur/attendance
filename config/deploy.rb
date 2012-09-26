require "bundler/capistrano"
require "rvm/capistrano"

settings_yml_path = "config/settings.yml"
config = YAML::load(File.open(settings_yml_path))
raise "not found deploy key in settings.yml. see settings.yml.example" unless config['deploy']['tusur']
application = config['deploy']['tusur']["application"]
raise "not found deploy.application key in settings.yml. see settings.yml.example" unless application
domain = config['deploy']['tusur']["domain"]
raise "not found deploy.domain key in settings.yml. see settings.yml.example" unless domain
port = config['deploy']['tusur']["port"]
raise "not found deploy.port key in settings.yml. see settings.yml.example" unless port
gateway = config['deploy']['tusur']["gateway"]
raise "not found deploy.gateway key in settings.yml. see settings.yml.example" unless gateway

set :application, application
set :domain, domain
set :port, port
set :gateway, gateway

set :rails_env, "production"
set :deploy_to, "/srv/#{application}"
set :use_sudo, false
set :unicorn_instance_name, "unicorn"

set :scm, :git
set :repository, "https://github.com/openteam-tusur/attendance.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :keep_releases, 7

set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,    "--deployment --quiet --binstubs"
set :bundle_without,  [:development, :test, :assets]
role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :assets do
  desc "Upload assets"
  task :upload, :roles => :app do
    run_locally("RAILS_ENV=development bin/rake assets:clean && RAILS_ENV=production bin/rake assets:precompile")
    top.upload "public/assets", "#{deploy_to}/shared/", :via => :scp, :recursive => true
    run "ln -s #{deploy_to}/shared/assets #{release_path}/public/assets"
  end
end
namespace :deploy do
  desc "Copy config files"
  task :config_app, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "HASK copy right unicorn.rb file"
  task :copy_unicorn_config do
    run "mv #{deploy_to}/current/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb.example"
    run "ln -s #{deploy_to}/shared/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb"
  end

  desc "Reload Unicorn"
  task :reload_servers do
    sudo "/etc/init.d/nginx reload"
    sudo "/etc/init.d/#{unicorn_instance_name} reload"
  end

  desc "Airbrake notify"
  task :airbrake do
    run "cd #{deploy_to}/current && RAILS_ENV=production TO=production bin/rake airbrake:deploy"
  end

  desc "Sunspot solr reindex"
  task :sunspot_reindex do
    run "cd #{deploy_to}/current && RAILS_ENV=production bin/rake sunspot:reindex"
  end

  desc "Update crontab tasks"
  task :crontab do
    run "cd #{deploy_to}/current && exec bundle exec whenever --update-crontab --load-file #{deploy_to}/current/config/schedule.rb"
  end
end

# deploy
after "deploy:finalize_update", "deploy:config_app"
after "deploy", "deploy:migrate"
after "deploy", "assets:upload"
after "deploy", "deploy:copy_unicorn_config"
after "deploy", "deploy:reload_servers"
after "deploy:reload_servers", "deploy:cleanup"
after "deploy", "deploy:crontab"
after "deploy", "deploy:airbrake"

# deploy:rollback
after "deploy:rollback", "deploy:reload_servers"