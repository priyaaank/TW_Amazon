class SilentAuction < ActiveRecord::Base
  before_validation :strip_whitespace
  before_save :strip_whitespace
  before_save :set_default_region
  
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
  validates :start_date, :presence => {:message => "Start date is required"}
  validates_date :start_date, :on => :create, :on_or_after => :today
  
  validates :end_date, :presence => {:message => "End date is required"}
  validates_datetime :end_date, :on_or_after => :start_date
  validates :end_date, :timeliness => {:on_or_before => lambda{|auction| auction.start_date + 2.months}, :type => :date}
 
  #scope :running, where(["start_date < :tomorrow AND open = :is_open", :tomorrow => Date.tomorrow, :is_open => true])
  #timezone = "Melbourne"
  #timezone = self
  #scope :running, where(["start_date < :today AND open = :is_open", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true])
  scope :running, lambda { |timezone| where(["start_date < :today AND open = :is_open", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true]) }
  
  #scope :future, where("start_date > ? AND open = ?", Date.today.to_s, true)
  #scope :future, where("start_date > ? AND open = ?", Time.zone.now.in_time_zone("Melbourne").to_date, true)
  scope :future, lambda { |timezone| where("start_date > ? AND open = ?", Time.zone.now.in_time_zone(timezone).to_date, true) }
  
  scope :closed, includes(:bids).where("bids.id IS NOT NULL AND open = ?", false)
  
  scope :expired, includes(:bids).where("bids.id IS NULL AND open = ?", false)

  scope :recent, order('"silent_auctions"."created_at" desc')
  #scope :ending_today, lambda { where("end_date <= ?", Date.today.to_s ) }#Time.zone.now ) }
  scope :ending_today, lambda { |timezone| where("end_date <= ?", (Time.zone.now.in_time_zone(timezone) + 10.minutes).to_date ) }
  
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
   # @max=Date.today+2.months
  end
  
 def set_default_region
     self.region ||= :AUS
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
=begin    
    @winner_id = ""
    @winner_amount = ""
    @winner = Bid.where("silent_auction_id = ? AND active = ?",self.id,true)
    @count = @winner.count
    if @count > 0
      @winner = @winner.order("amount ASC").last!
      @winner_id = User.find(@winner.user_id).username + "@thoughtworks.com"
      @winner_amount = @winner.amount
      UserMailer.winner_notification(self.title,@count,@winner_id,@winner_amount).deliver
      UserMailer.administrator_notification_close(self.title,@count,@winner_id,@winner_amount).deliver
    else
      UserMailer.administrator_notification_expired(self.title).deliver
    end
=end      
    self.save!
  end

  def get_regions
    config_file = "#{Rails.root}/config/region.yml"
    YAML.load_file(config_file)    
  end

  def get_region_config(region)
    yaml = self.get_regions
    yaml[region]
  end

  def self.close_auctions_ending_today
    self.where("open = ?", true).each do |auction|
      puts "*" * 15
      region = auction.region
      puts region
      timezone = auction.get_region_config(region)["timezone"]
      puts timezone
      puts auction.end_date
      puts (Time.zone.now.in_time_zone(timezone) + 10.minutes).to_date
      if auction.end_date < (Time.zone.now.in_time_zone(timezone) + 10.minutes).to_date        
        puts "CLOSED!!!"
        auction.change_to_closed
      end
    end
  end
  
  def self.close_auctions_ending_today_OLD
  #def self.close_auctions_ending_today_OLD(timezone)
    timezone = "Melbourne"
    self.ending_today(timezone).each do | auction |
      #auction.change_to_closed if auction.open?
      if auction.open == true
        auction.change_to_closed
=begin
        @winner_id = ""
        @winner_amount = ""
        @winner = Bid.where("silent_auction_id = ? AND active = ?",auction.id,true)
        @count = @winner.count
        if @count > 0
          @winner = @winner.order("amount ASC").last!
          @winner_id = User.find(@winner.user_id).username + "@thoughtworks.com"
          @winner_amount = @winner.amount
          UserMailer.winner_notification(auction.title,@count,@winner_id,@winner_amount).deliver
          UserMailer.administrator_notification_close(auction.title,@count,@winner_id,@winner_amount).deliver
        else
          UserMailer.administrator_notification_expired(auction.title).deliver
        end
=end        
      end 
    end
  end
end
