class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validates :amount, :presence => { :message => "is required" }, :numericality => true #, :numericality => {:less_than_or_equal_to => 9999.99}
  validates :amount, :format => { :with => /^\d+(\.\d{0,2})?$/, :message => "can only have 2 decimal places" }
  validates :silent_auction_id, :presence => true, :uniqueness => {:scope => :user_id, :message => 'You cannot place multiple bids for an auction.'}
  validate :validate_bid_limit
  validate :amount_must_be_greater_than_auction_min_price
  validate :auction_must_not_be_closed

  attr_accessible :amount, :active, :silent_auction_id, :created_at, :as => [:default, :admin]
  attr_accessible :user_id, :as => :admin

  scope :active, where(:active => true)
  scope :highFirst, order('amount DESC')
  scope :earlier, order('created_at ASC')
  scope :recent, order('"silent_auctions"."created_at" desc')

  def validate_bid_limit
    return unless amount
    item = SilentAuction.find(silent_auction_id)
    maximum = item.region.maximum.to_f
    currency = item.region.currency
    valid = self.amount < maximum
    unless valid
      warning = number_with_delimiter(maximum, :delimiter => ",").to_s
      errors.add(:amount, " can't exceed #{currency} #{warning}")
    end
    return valid
  end

  def number_with_delimiter(number, options = {})
    options.symbolize_keys!

    begin
      Float(number)
    rescue ArgumentError, TypeError
      if options[:raise]
        raise InvalidNumberError, number
      else
        return number
      end
    end
  end

  def auction_must_not_be_closed
    # not allow placing bid for closed auction
    errors.add :silent_auction_id, "cannot be placed for closed auction" unless SilentAuction.find(self.silent_auction_id).open
  end

  def amount_must_be_greater_than_auction_min_price
    if self.amount != nil
      #errors.add :amount, "cannot be less than minimum price" unless SilentAuction.find(self.silent_auction_id).min_price <= self.amount
      auction = SilentAuction.find(self.silent_auction_id)
      if auction.item_type == 'Silent Auction'
        errors.add :amount, "cannot be less than minimum price" unless auction.min_price <= self.amount
      else
        highestBid = auction.bids.active.highFirst.earlier.first
        if highestBid.nil?
          errors.add :amount, "cannot be less than minimum price" unless auction.min_price <= self.amount
        else
          errors.add :amount, "must be higher than the current highest bid" unless highestBid.amount < self.amount
        end
      end
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
