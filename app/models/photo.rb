class Photo < ActiveRecord::Base
  belongs_to :silent_auction
  attr_accessible :image, :remote_image_url

  mount_uploader :image, PhotoUploader
end
