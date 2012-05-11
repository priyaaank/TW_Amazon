class SilentAuction < ActiveRecord::Base
  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction
  has_many :assets, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :assets

  attr_accessible :title, :description, :open, :min_price, :end_date 
  before_save :strip_whitespace

  validates :title, :presence => { :message => "Title is required" } ,
                    :length => { :maximum => 255, :message => "Title is too long (Maximum 255 characters)" },
                    :uniqueness => {:message => "Duplicate title not allowed"}

  validates :description, :presence => { :message => "Description is required" },
                          :length => { :maximum => 500, :message => "Description is too long (Maximum 500 characters)" }

  validates :min_price, :presence => { :message => "is required"},
                        :numericality => { :greater_than => 0, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 9999.99},
                        :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }

  scope :running, where(:open => true)
  scope :closed, joins(:bids).where(:open => false)
  scope :recent, order('created_at desc')
  scope :ending_today, lambda { where("end_date < ?", Time.zone.now ) }
  scope :expired, joins(<<-SQL
    LEFT OUTER JOIN bids on silent_auctions.id = bids.silent_auction_id
    WHERE bids.id is null
    AND silent_auctions.open = 'f'
  SQL
  )
   
  def initialize(*params)
    super(*params)
    self.end_date = 2.weeks.from_now.to_date
  end

  def strip_whitespace
    self.title = self.title.strip
  end

  def close
    if self.bids.active.count == 0
      errors.add :base, "Auction with no active bid cannot be closed"
      false
    else
      change_to_closed
      true
    end
  end

  def change_to_closed
    self.open = false
    self.save!
  end

  def self.close_auctions_ending_today
    self.ending_today.each do | auction |
      auction.change_to_closed if auction.open? 
    end
  end
end
