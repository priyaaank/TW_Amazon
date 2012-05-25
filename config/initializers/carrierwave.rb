if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

CarrierWave.configure do |config|
  # following 2 lines is for Heroku cached upload since Heroku does not allow writing to file system
  # this might not work if we change to use more than 1 dyno on heorku and has different tmp files
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => ENV['S3_KEY'],       # required
      :aws_secret_access_key  => ENV['S3_SECRET'],       # required
  }
  config.fog_directory  = ENV['S3_BUCKET']                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end