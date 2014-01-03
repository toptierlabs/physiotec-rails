# config/initializers/01_s3.rb
S3_CONFIG = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]