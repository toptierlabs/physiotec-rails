S3_CONFIG = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]
AWS.config(access_key_id: S3_CONFIG['S3_KEY'], secret_access_key: S3_CONFIG['S3_SECRET'], region: S3_CONFIG['S3_REGION'])