set :rails_env, "production"
#set :domain,  "physiotec.com"
#role :web, domain
#role :app, domain
#role :db,  domain, :primary => true
set :branch, 'master'
set :deploy_to, "/var/www/physiotec"