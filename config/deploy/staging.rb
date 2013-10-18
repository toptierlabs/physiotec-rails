set :rails_env, "staging"
set :branch, 'develop'
#set :domain,  "librovillepreview.com"
#role :web, domain
#role :app, domain
#role :db,  domain, :primary => true
set :deploy_to, "/var/www/staging-physiotec"