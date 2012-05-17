class Photo < ActiveRecord::Base
  belongs_to :silent_auction
  attr_accessible :caption, :image, :image_cache

  validates :caption, :length => { :maximum => 200 }
  #validates :image, :presence => { :message => 'Image file is required' }

  mount_uploader :image, PhotoUploader

end
