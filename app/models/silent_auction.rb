class SilentAuction < ActiveRecord::Base
  before_validation :strip_whitespace
  before_save :strip_whitespace
  before_save :check_dates, :if => :open?

  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction

  has_many :photos, :dependent => :destroy, :inverse_of => :silent_auction
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? && attributes['image_cache'].blank? && attributes['caption'].blank? }

  attr_accessible :title, :description, :open, :min_price, :start_date, :end_date, :photos_attributes, :region

  validates :title, :presence => { :message => "Title is required" } ,
                    :length => { :maximum => 255, :message => "Title is too long (Maximum 255 characters)" },
                    :uniqueness => { :message => "Duplicate title not allowed"}

  validates :description, :presence => { :message => "Description is required" },
                          :length => { :maximum => 500, :message => "Description is too long (Maximum 500 characters)" }

  validates :min_price, :presence => { :message => "is required"},
                        :numericality => { :greater_than => 0, :greater_than_or_equal_to => 0.01}, #:less_than_or_equal_to => 9999.99},
                        :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }
                        
  #scope :running, where(:open => true)
  scope :running, where("start_date <= ? AND open = ?", Date.today.to_s, true)
  scope :future, where("start_date > ? AND open = ?", Date.today.to_s, true)
  scope :closed, includes(:bids).where("bids.id IS NOT NULL AND open = ?", false)
  scope :expired, includes(:bids).where("bids.id IS NULL AND open = ?", false)

  scope :recent, order('"silent_auctions"."created_at" desc')
  scope :ending_today, lambda { where("end_date <= ?", Date.today.to_s ) }#Time.zone.now ) }
  
  def initialize(*params)
    super(*params)
    #self.end_date = 2.weeks.from_now.to_date
    #self.end_date = Time.zone.now
    #self.end_date = Time.now
  end

  def strip_whitespace
    if self.title != nil
      self.title = self.title.strip
    end
    if self.description != nil
      self.description = self.description.strip
    end
  end

  #def validate_on_create
  #def check_end_date
  def check_dates
    if self.region == nil then 
      self.region = "AUS"
    end

    isvalid = true
    if self.start_date == nil then 
      isvalid = false
      errors.add(:start_date, "Star Date is required")
    else  
    max_end_date = self.start_date + 2.months
    if self.start_date < Date.today  then 
      isvalid = false
      errors.add(:start_date, "The earliest acceptable start date is today's date")
    
    end
  end
     
    if self.end_date == nil then
     isvalid = false
     errors.add(:end_date, "End Date is required")
    elsif self.end_date < self.start_date || max_end_date < self.end_date then 
     
      isvalid = false
      errors.add(:end_date, "End date must be between the start date and 2 months after it")
      
    end
    if isvalid == false
      false
    end
    #elsif (self.end_date > (2.months.from_now.to_date))
  end
  
  def close
    if self.bids.active.count == 0
      errors.add :message, "Auction with no active bid cannot be closed"
      false
    else
      change_to_closed
      true
    end
  end

  def has_active_bid
    self.bids.active.count > 0
  end

  def change_to_closed
    self.open = false
    @winner_id = ""
    @winner_amount = ""
    @winner = Bid.where("silent_auction_id = ? AND active = ?",self.id,true)
    @count = @winner.count
    if @count > 0
      @winner = @winner.order("amount ASC").last!
      @winner_id = User.find(@winner.user_id).username + "@thoughtworks.com"
      @winner_amount = @winner.amount
    end    
    #UserMailer.registration_confirmation(self.title,self.bids.active.count,@winner_id,@winner_amount).deliver
    UserMailer.registration_confirmation(self.title,@count,@winner_id,@winner_amount)#.deliver  
    self.save!
  end

  def self.close_auctions_ending_today
    self.ending_today.each do | auction |
      auction.change_to_closed if auction.open? 
    end
  end
end
