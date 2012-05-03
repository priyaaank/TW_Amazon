class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validate :auction_closed

  validates :amount,
            :presence => { :message => "amount is required" } ,
            :numericality => { :greater_than => 0, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 9999.99},
            :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }

  validates :silent_auction_id, :presence => true, :uniqueness => {:scope => :user_id, :message => 'You cannot place multiple bids for an auction.'}

  attr_accessible :amount, :active, :silent_auction_id

  scope :active, where(:active => true)
  scope :highFirst, order('amount DESC')
  scope :earlier, order('created_at ASC')

  def auction_closed
    # not allow placing bid for closed auction
    errors.add :silent_auction_id, "cannot be placed for closed auction" unless SilentAuction.find(self.silent_auction_id).open
  end

  def withdraw
    if SilentAuction.find(self.silent_auction_id).open
      self.active = false
      self.save!
      true
    else
      errors.add :base, "Auction has been closed! Bid cannot be withdrawn anymore."
      false
    end
  end

end
