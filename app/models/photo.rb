class Photo < ActiveRecord::Base
  belongs_to :silent_auction
  attr_accessible :image, :remote_image_url, :image_cache, :remove_image

  mount_uploader :image, PhotoUploader

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
        "name" => read_attribute(:image),
        "size" => image.size,
        "url" => image.url,
        "thumbnail_url" => image.thumb.url,
        "delete_url" => picture_path(:id => id),
        "delete_type" => "DELETE"
    }
  end
end
