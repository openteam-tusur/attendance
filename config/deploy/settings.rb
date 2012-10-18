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
set :bundle_without,  [:development, :test]
role :web, domain
role :app, domain
role :db,  domain, :primary => true