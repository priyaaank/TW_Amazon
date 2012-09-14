class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validates :amount, :presence => { :message => "is required" } #, :numericality => {:less_than_or_equal_to => 9999.99}
  validate :amount_must_not_be_less_than_auction_min_price
  validates :amount, :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }
  validate :auction_must_not_be_closed
  validates :silent_auction_id, :presence => true, :uniqueness => {:scope => :user_id, :message => 'You cannot place multiple bids for an auction.'}

  attr_accessible :amount, :active, :silent_auction_id, :created_at

  scope :active, where(:active => true)
  scope :highFirst, order('amount DESC')
  scope :earlier, order('created_at ASC')
  scope :recent, order('"silent_auctions"."created_at" desc')

  def auction_must_not_be_closed
    # not allow placing bid for closed auction
    errors.add :silent_auction_id, "cannot be placed for closed auction" unless SilentAuction.find(self.silent_auction_id).open
  end

  def amount_must_not_be_less_than_auction_min_price
    if self.amount != nil
      errors.add :amount, "cannot be less than minimum price" unless SilentAuction.find(self.silent_auction_id).min_price <= self.amount
    end
  end

  def withdraw
    if SilentAuction.find(self.silent_auction_id).open
      self.turn_inactive
      true
    else
      errors.add :base, "Auction has been closed! Bid cannot be withdrawn anymore."
      false
    end
  end

  def turn_inactive
    self.active = false
    self.save!
  end

end
