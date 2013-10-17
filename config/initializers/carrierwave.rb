CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAISHIKVJWE3NYHUZQ',       # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'us-west-2'                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.amazonaws.com',             # optional, defaults to nil
    #:endpoint               => 'http://physiotec-rails.s3.amazonaws.com/' # optional, defaults to nil
  }
  #config.storage = :fog
  config.fog_directory  = 'physiotec-rails'                                 # required
  #config.fog_public     = true                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end