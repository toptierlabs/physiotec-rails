set :stages, %w(production staging)
set :default_stage, "staging"
#set :rvm_type, :user

#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#set :rvm_ruby_string, 'ruby-1.9.3-p327@gems'

require 'capistrano/ext/multistage'
require "bundler/capistrano"
#require 'rvm/capistrano'

set :application, "physiotec"
set :repository, "git@github.com:toptierlabs/physiotec-rails.git"
set :scm, :git
set :scm_verbose, false
set :keep_releases, 5

desc "check production task"
task :check_production do
  if stage.to_s == "production"
    puts " \n Are you REALLY sure you want to deploy to production?"
    puts " \n Enter 'iamsure' to continue\n "
    password = STDIN.gets[0..6] rescue nil

    if password != 'iamsure'
      puts "\n !!! WRONG PASSWORD !!!"
      exit
    end
  end
end

set :aws_private_key_path, "~/.ssh/physiotec.pem"



namespace :setup_server do
  desc "adds a user and uploads his id_rsa.pub to the EC2 instance's deploy users authorized_keys2 file"
  task :create_deploy_user do

    # \\n becomes \n
    commands = <<-SH.split("\n").map(&:strip).join(";")
      sudo echo hi
      sudo groupadd admin
      sudo useradd -d /home/#{user} -s /bin/bash -m #{user}
      echo #{user}:#{password} | chpasswd
      sudo usermod -a -G admin #{user}
      sudo mkdir /home/#{user}/.ssh
      sudo chmod 700 /home/#{user}.ssh
      sudo chown #{user} /home/#{user}/.ssh
      sudo chgrp #{user} /home/#{user}/.ssh
      SH

    setup_user = <<-SH
      ssh -i #{aws_private_key_path} @#{location} "script -c \\"#{commands}\\" /dev/null"
    SH

    puts setup_user
    system setup_user

    add_my_ssh_key
  end

  task :add_my_ssh_key do
    ssh_options[:keys].each do |key|
      authorized_keys2 = "/home/#{user}/.ssh/authorized_keys2"

      commands = <<-SH.split("\n").map(&:strip).join(";")
        sudo touch #{authorized_keys2}
        sudo cat /tmp/my_key.pub | sudo tee -a #{authorized_keys2}
        sudo rm /tmp/my_key.pub
        sudo chmod 600 #{authorized_keys2}
        sudo chown #{user} #{authorized_keys2}
        sudo chgrp #{user} #{authorized_keys2}
        SH

      setup_keys = <<-SH.strip
        scp -i #{aws_private_key_path} #{key} #{user}@#{location}:/tmp/my_key.pub
        ssh -i #{aws_private_key_path} #{user}@#{location} "script -c \\"#{commands}\\" /dev/null"
        SH

      puts setup_keys
      system setup_keys
    end
  end
end

namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --without=test --no-update-sources"
  end

end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run "cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} assets:precompile --trace"
    end
  end
end



# The address of the remote host on EC2 (the Public DNS address)
set :location, "ec2-54-200-192-119.us-west-2.compute.amazonaws.com"
set :gemhome, "/var/lib/gems/1.8/gems/"
# setup some Capistrano roles
role :app, location
role :web, location
role :db,  location, :primary => true

# Set up SSH so it can connect to the EC2 node - assumes your SSH key is in ~/.ssh/id_rsa
set :user, "ec2-user"
default_run_options[:pty] = true
ssh_options[:user] = 'ec2-user'
ssh_options[:keys] = ["~/.ssh/physiotec.pem"]

before "deploy", "check_production"
after "deploy:finalize_update", "deploy:assets:precompile"