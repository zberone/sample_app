require 'mina/bundler'
    require 'mina/rails'
    require 'mina/git'
    
   # set :user, 'deploy'
    set :domain, 'sl@192.168.11.190'
    set :deploy_to, '/home/sl/rwork/sample_app'
    set :repository, 'https://github.com/zberone/sample_app.git'
    set :branch, 'sign'
    set :forward_agent, true
    set :app_path, lambda { "#{deploy_to}/#{current_path}" }
    set :stage, 'production'
  #  set :rvm_path, '/home/deploy/.rvm/bin/rvm'

    set :shared_paths, ['config/database.yml', 'log']

    task :environment do
    #  invoke :'rvm:use[ruby-2.0.0-p643@default]'
    end

    task :setup => :environment do
      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp"]

      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"] 

      queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/log"]
      queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/log"] 

      queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
      queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
    end

    desc "Deploys the current version to the server."
    task :deploy => :environment do
      to :before_hook do
      end
      deploy do
        invoke :'git:clone'
        invoke :'deploy:link_shared_paths'
        invoke :'bundle:install'
   #     queue! "cd #{app_path} & RAILS_ENV=#{stage} bundle exec rake db:create"
        invoke :'rails:db_migrate'
    #    queue! "cd #{app_path} & RAILS_ENV=#{stage} bundle exec rake db:seed"
        invoke :'rails:assets_precompile'
        invoke :'deploy:cleanup'
        invoke :'puma:restart'

        to :launch do      
        end
      end
    end

    namespace :puma do 
      desc "Start the application"
      task :start do
        queue 'echo "-----> Start Puma"'  
        queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh start", :pty => false
      end

      desc "Stop the application"
      task :stop do
        queue 'echo "-----> Stop Puma"'
        queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh stop"
      end

      desc "Restart the application"
      task :restart do
        queue 'echo "-----> Restart Puma"'
        queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh restart"
      end
    end