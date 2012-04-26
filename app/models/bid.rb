class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validates :amount, :presence => { :message => "Bid amount is required" }

  attr_accessible :amount, :active, :silent_auction_id

  scope :active, where(:active => true)
  scope :highFirst, order('amount DESC')
  scope :earlier, order('created_at ASC')

end
