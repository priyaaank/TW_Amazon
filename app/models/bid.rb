class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validates :amount,
            :presence => { :message => "amount is required" } ,
            :numericality => { :greater_than => 0, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 9999.99},
            :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }

            attr_accessible :amount, :active, :silent_auction_id

  scope :active, where(:active => true)
  scope :highFirst, order('amount DESC')
  scope :earlier, order('created_at ASC')

end
