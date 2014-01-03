# config/initializers/02_common_options.rb
COMMON_OPTIONS = YAML.load_file("#{Rails.root}/config/common_options.yml")[Rails.env]