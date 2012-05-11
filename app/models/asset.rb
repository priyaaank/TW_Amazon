# multiple file attachments tutorial
# http://blog.castitt.com/2011/02/multiple-file-uploads-using-jquery-and-paperclip/

class Asset < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true

  has_attached_file :data,
                    :storage => :s3,
                    :bucket => ENV['S3_BUCKET_NAME'],
                    :s3_credentials => {
                        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    :bucket => "TWGS-test"

  #Set number to the Max Attachments allowed for owner
  Max_Attachments = 5
  Max_Attachment_Size = 2.megabyte

  def url(*args)
    data.url(*args)
  end

  def name
    data_file_name
  end

  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end
end
