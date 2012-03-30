class SilentAuction < ActiveRecord::Base
  validates :title, :presence => { :message => "is required" } , :length => { :maximum => 255 }
  validates :description, :presence => { :message => "is required" }, :length => { :maximum => 500 }
  validates :open, :presence => true


end
