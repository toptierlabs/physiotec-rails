CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAISHIKVJWE3NYHUZQ',       # required
    :aws_secret_access_key  => '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',                        # required
    :region                 => 'us-west-2'                  # optional, defaults to 'us-east-1'
    #:host                   => 's3.amazonaws.com',             # optional, defaults to nil
    #:endpoint               => 'http://physiotec-rails.s3.amazonaws.com/' # optional, defaults to nil
  }
  config.fog_directory  = Rails.env.production? ? 'physiotec-rails' :  'physiotec-rails-dev'                                # required
  config.fog_public     = Rails.env.production? ? true :  false #true is required for config.asset_host
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  config.asset_host = "http://d10wzy8tdhygcz.cloudfront.net"
end