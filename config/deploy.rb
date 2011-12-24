$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
load 'deploy/assets'
require 'rvm/capistrano'
require 'capistrano_colors'
require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "bicing_stats"
set :deploy_to, "/var/www/#{application}"

set :user, "deploy"

set :scm, :git
set :repository, "git@github.com:knoopx/bicing_stats.git"

server "r19498.ovh.net", :web, :app, :db, :primary => true

namespace :deploy do
  [:start, :stop].each do |task_name|
    desc "#{task_name} task is a no-op with mod_rails"
    task(task_name, :roles => :app) {}
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

namespace :db do
  desc "Backup the remote production database"
  task :backup, :roles => :db, :only => {:primary => true} do
    backup_path = File.join(shared_path, "backups")
    run "mkdir -p #{backup_path}"
    backup_filename = File.join(backup_path, "#{application}-#{release_name}.sql.bz2")
    db_settings = YAML::load_file(File.join(File.dirname(__FILE__), "database.yml"))['production']

    params = ["-q", "--single-transaction"]
    params << "--password=#{db_settings['password']}" if db_settings.include?("password")
    params << "-u #{db_settings['username']}" if db_settings.include?("username")
    run "mysqldump #{params.join(" ")} #{db_settings['database']} | bzip2 -c > #{backup_filename}"
    run "echo | mutt -a #{backup_filename} -s '[BACKUP] #{application} - #{release_name}' #{backup_email}"
  end

  desc "Load production data into development database"
  task :dump, :roles => :db, :only => {:primary => true} do
    require 'yaml'

    puts "Dumping production database"
    database = YAML::load_file('config/database.yml')
    filename = "#{application}-dump-#{Time.now.strftime '%Y%m%d-%H%M%S'}.sql"

    on_rollback do
      delete "/tmp/#{filename}"
      delete "/tmp/#{filename}.gz"
    end

    remote_args = {}
    remote_args["-u"] = database["production"]['username'] || "root"
    remote_args["-h"] = database["production"]['host'] || "localhost"
    remote_args["-p"] = database["production"]['password'] if database["production"]['password']

    cmd = "mysqldump #{remote_args.map { |k, v| [k, v].join }.join(" ")} #{database["production"]["database"]} > /tmp/#{filename}"
    run(cmd) do |channel, stream, data|
      puts data
    end

    # compress the file on the server
    puts "Compressing remote data"
    run "gzip -9 /tmp/#{filename}"
    puts "Fetching remote data"
    get "/tmp/#{filename}.gz", "/tmp/#{filename}.gz"

    local_args = {}
    local_args["-u"] = database['development']['username'] || "root"
    local_args["-h"] = database['development']['host'] || "localhost"
    local_args["-p"] = database['development']['password'] if database['development']['password']

    run_locally "gzip -d /tmp/#{filename}.gz"
    run_locally "mysql #{local_args.map { |k, v| [k, v].join }.join(" ")} #{database['development']['database']} < /tmp/#{filename}"
    run_locally "rm /tmp/#{filename}"
  end
end
