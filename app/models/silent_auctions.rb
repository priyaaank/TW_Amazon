class SilentAuctions < ActiveRecord::Base
  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :description, :presence => true, :length => { :maximum => 500 }
  validates :open, :presence => true
end
