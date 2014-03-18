CarrierWave.configure do |config|
  config.cache_dir = 'carrierwave'
  if Rails.env.production?
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET']
    }
    config.fog_directory = ENV['S3_BUCKET']
    config.fog_public = false
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.enable_processing = true
  else
    config.storage = :file
    config.enable_processing = false
  end
  config.base_path = ''
end