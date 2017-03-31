require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/unicorn'
require "mina_sidekiq/tasks"
    
   # set :user, 'deploy'
    set :domain, 'sl@192.168.11.190'
    set :deploy_to, '/var/www/sample_app'
    
    set :forward_agent, false
    set :stage, 'production'
  #  set :rvm_path, '/home/deploy/.rvm/bin/rvm'
          
set :forward_agent, false

#设置git地址及分支
set :repository, 'https://github.com/zberone/sample_app.git'
set :branch, 'sign'

set :shared_paths, ['config/database.yml', 'config/yetting.yml','config/symmetric-encryption.yml','log']

#设置sidekiq的进程保存地址
set :sidekiq_pid, "#{deploy_to}/tmp/pids/sidekiq.pid"


#设置unicorn pid 及 进程启动环境
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"
set :unicorn_env, 'production'

task :environment do
#  invoke :'rvm:use[ruby-2.0.0@default]'
end

task :setup => :environment do
  # unicorn and sidekiq needs a place to store its pid file
  queue! %[mkdir -p "#{deploy_to}/tmp/sockets/"]
  queue! %[mkdir -p "#{deploy_to}/tmp/pids/"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/yetting.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/symmetric-encryption.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml','yetting.yml', 'symmetric-encryption.yml'."]

  queue %[
    repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
    repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
    if [ -z "${repo_port}" ]; then repo_port=22; fi ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
 #   invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      # sidekiq stop accepting new workers
      invoke :'sidekiq:quiet'
      invoke :'sidekiq:restart'
      invoke :'unicorn:restart'
    end
  end
end