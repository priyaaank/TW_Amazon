class Bid < ActiveRecord::Base
  belongs_to :silent_auction, :inverse_of => :bids
  belongs_to :user, :inverse_of => :bids

  validates :amount, :presence => { :message => "Bid amount is required" }

  attr_accessible :amount, :active, :silent_auction_id


  #attr_accessor :accessible
  #
  #private
  #def mass_assignment_authorizer(role = :default)
  #  if accessible == :all
  #    self.class.protected_attributes
  #  else
  #    super + (accessible || [])
  #  end
  #end
end
