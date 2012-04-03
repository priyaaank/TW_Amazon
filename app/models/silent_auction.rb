class SilentAuction < ActiveRecord::Base
  validates :title, :presence => { :message => "is required" } , :length => { :maximum => 255 }
  validates :description, :presence => { :message => "is required" }, :length => { :maximum => 500 }

  scope :running, where(:open => true)
  scope :closed, where(:open => false)
end
