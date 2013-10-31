# config/initializers/load_config.rb
AUTH_CONFIG = YAML.load_file("#{Rails.root}/config/auth_config.yml")[Rails.env]