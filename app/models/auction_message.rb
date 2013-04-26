class AuctionMessage < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :auction_messages
  attr_accessible :creator, :message, :silent_auction_id, :as  => [:default, :admin]
  validates :message, :presence => {:message => "Message is required"}
end
