require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)
# require 'mina/puma'
# require 'mina/logs'
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'sample_app'
set :domain, 'sl@192.168.11.190'
set :deploy_to, '/home/sl/rwork/sample_app'
set :repository, 'https://github.com/zberone/sample_app.git'
set :branch, 'sign'

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
 set :shared_dirs, fetch(:shared_dirs, []).push('log')
 set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'log')
# set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml']

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0}
  ['log', 'config', 'public/upload', 'tmp/pids', 'tmp/sockets'].each do |dir|
        command %{mkdir -p "fetch(:deploy_to)/shared/#{dir}"}
        command %{chmod g+rx,u+rwx "fetch(:deploy_to)/shared/#{dir}"}
  end

  ['config/database.yml', 'config/secrets.yml', 'config/puma.rb'].each do |file|
        command %{touch "fetch(:deploy_to)/shared/#{file}"}
        comment %{Be sure to edit 'shared/#{file}'.}
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
