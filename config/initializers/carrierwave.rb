CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.

    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => S3_CONFIG['S3_KEY'],
    :aws_secret_access_key => S3_CONFIG['S3_SECRET'],
    :region                => S3_CONFIG['S3_REGION']
  }

 
  # For testing, upload files to local `tmp` folder.
  if Rails.env.test?# || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end
  config.fog_public = false
  config.cache_dir = "#{Rails.root}/tmp/uploads"
 
  config.fog_directory    = S3_CONFIG['S3_BUCKET_NAME']
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }

end