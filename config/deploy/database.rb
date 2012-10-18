# remote database.yml
database_yml_path = "config/database.yml"
config = YAML::load(capture("cat #{deploy_to}/shared/#{database_yml_path}"))
adapter = config[rails_env]["adapter"]
database = config[rails_env]["database"]
db_username = config[rails_env]["username"]
host = config[rails_env]["host"]

#local database.yml
config = YAML::load(File.open(database_yml_path))
local_rails_env = 'development'
local_adapter = config[local_rails_env]["adapter"]
local_database = config[local_rails_env]["database"]
local_db_username = config[local_rails_env]["username"]

set :timestamp, Time.now.strftime("%Y-%m-%d-%H-%M")
namespace :db do
  desc "upload local database to remote server"
  task :export do
    if adapter == "postgresql"
      run_locally("pg_dump -O #{local_database} > tmp/#{local_database}-#{timestamp}.sql")
      upload "tmp/#{local_database}-#{timestamp}.sql", "#{deploy_to}/shared/database/#{local_database}-#{timestamp}.sql"
      sudo "/etc/init.d/#{unicorn_instance_name} stop"
      run "cd #{deploy_to}/current && RAILS_ENV=production bin/rake db:drop && RAILS_ENV=production bin/rake db:create"
      run "psql -d #{database} -h #{host} -U #{db_username} -f #{deploy_to}/shared/database/#{local_database}-#{timestamp}.sql"
      sudo "/etc/init.d/#{unicorn_instance_name} start"
    else
      puts "Cannot backup, adapter #{adapter} is not implemented for backup yet"
    end
  end

  desc "download data to local database"
  task :import do
    run_locally("bin/rake sunspot:solr:stop; true")
    run_locally("bin/rake db:drop")
    run_locally("bin/rake db:create")
    run_locally("ssh #{gateway} ssh #{domain} -p #{port} pg_dump -U #{db_username} -h #{host} #{database} | psql #{local_database}")
    run_locally("bin/rake sunspot:solr:start")
    run_locally("bin/rake db:migrate")
    run_locally("bin/rake db:migrate RAILS_ENV=test")
    run_locally("bin/rake sunspot:reindex")
  end
end
