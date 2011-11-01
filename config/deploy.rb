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