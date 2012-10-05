class SilentAuction < ActiveRecord::Base
  before_validation :strip_whitespace
  before_save :strip_whitespace
  before_save :set_default_region
  before_save :validate_price_limit
  
  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction

  has_many :photos, :dependent => :destroy, :inverse_of => :silent_auction
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? && attributes['image_cache'].blank? && attributes['caption'].blank? }

  attr_accessible :title, :description, :open, :min_price, :start_date, :end_date, :photos_attributes, :region, :category, :creator, :item_type

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
  
  validates :category, :presence => { :message => "Please select a category" }
 
  scope :running, lambda { |timezone| where(["start_date < :today AND open = :is_open", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true]) }
  scope :running_auction_for_admin, lambda { |timezone| where(["start_date < :today AND open = :is_open", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true]) }
  scope :running_auction_for_user, lambda { |timezone,username| where(["start_date < :today AND open = :is_open AND creator <> :user_name", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true, :user_name => username]) }
  
  scope :future, lambda { |timezone| where("start_date > ? AND open = ?", Time.zone.now.in_time_zone(timezone).to_date, true) }
  
  #scope :closed, includes(:bids).where("bids.id IS NOT NULL AND open = ?", false)
  scope :closed, includes(:bids).where("bids.id IS NOT NULL AND bids.active = ? AND open = ?", true, false)
  
  #scope :expired, includes(:bids).where("bids.id IS NULL AND open = ?", false)
  #scope :expired, includes(:bids).where("(bids.id IS NULL OR (bids.id IS NOT NULL AND bids.active = ?)) AND open = ?", false, false)
  #Local  SQL command: SilentAuction.includes(:bids).select("*,count(*)").where("(bids.id is null or bids.active='f') and silent_auctions.open='f'").group("silent_auctions.id").having("count(*)>0").count
  #Heroku SQL command: SilentAuction.includes(:bids).select("*,count(*)").where("bids.id is not null AND bids.active='t' AND silent_auctions.open='f'").group("silent_auctions.id,bids.id").having("count(*)<1")
  #scope :expired, includes(:bids).select("*,count(*)").where("(bids.id IS NULL OR bids.active = ?) AND silent_auctions.open = ?", false, false).group("silent_auctions.id").having("count(*)>0")
  #scope :expired, includes(:bids).select("*,count(bids.id)").where("(bids.id IS NULL OR (bids.id IS NOT NULL AND bids.active=?)) AND silent_auctions.open=?",false, false).group("silent_auctions.id")
  scope :expired, includes(:bids).where("silent_auctions.open = ? AND silent_auctions.id NOT IN (select distinct silent_auction_id from bids where active = ?)", false, true)  
  #SilentAuction.joins(:bids).select("*,count(bids.id)").where("bids.active=?",true).group("silent_auctions.id").count
  #SilentAuction.joins(:bids).select("*,count(bids.id)").where("bids.active=?",false).group("silent_auctions.id").count
  #silent_auctions.id 13 & 9 are in both

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
  
  def validate_price_limit
    region = self.region
    puts region
    maximum = self.get_region_config(region)["maximum"].to_f
    puts maximum
    currency = self.get_region_config(region)["currency"]
    isvalid = true
    if self.min_price > maximum
      isvalid = false
      errors.add(:min_price, " can't exceed #{currency} #{number_with_delimiter(maximum, :delimiter => ',')}")
    end 
    return isvalid
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

    defaults = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
    options = options.reverse_merge(defaults)

    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
    parts.join(options[:separator]).html_safe

  end
    
  def set_default_region
     #self.region ||= :AUS
     if self.region.nil? then
       self.region = "AUS"
     end
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
    unless Rails.application.config.test_mode 
      self.send_notification_email(self)
    end
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
        #auction.send_notification_email(auction)
      end
      
      
      # to send email notification when the auction of an item STARTS
      current_time = Time.zone.now.in_time_zone(timezone) + 10.minutes
      if current_time.hour == 0 && auction.start_date == current_time.to_date
        @silent_auction = auction
        unless Rails.application.config.test_mode 
          #UserMailer.send_announcement_to_other_users(@silent_auction).deliver
        end                
      end
    end    
  end
  
  def send_notification_email(auction)
    @winner_id = ""
    @winner_amount = ""
    @winner = Bid.where("silent_auction_id = ? AND active = ?",auction.id,true)
    @count = @winner.count
    @admins = User.where("admin = ? AND region = ?", true, auction.region)
    @alladmins = ""
    @admins.each do |admin|
      if @alladmins != "" then 
        @alladmins = @alladmins + ", "
      end
      @alladmins = @alladmins + admin.username + "@thoughtworks.com"
    end
    if @count > 0
      @winner = @winner.order("amount ASC").last!
      @winner_id = User.find(@winner.user_id).username + "@thoughtworks.com"
      #@winner_amount = @winner.amount
      @winner_amount = get_region_config(self.region)['currency'] + " " + number_with_delimiter(@winner.amount)
      if User.find(@winner.user_id).email == nil
        UserMailer.winner_notification(auction.title,@count,@winner_id,@winner_amount,auction.creator).deliver
      else if User.find(@winner.user_id).email == 'on'
          UserMailer.winner_notification(auction.title,@count,@winner_id,@winner_amount,auction.creator).deliver
        end
      end
      if User.find_by_username(auction.creator).email == nil
        UserMailer.administrator_notification_close(auction.title,@count,@winner_id,@winner_amount,@alladmins,auction.creator).deliver
      else if User.find_by_username(auction.creator).email == 'on'
          UserMailer.administrator_notification_close(auction.title,@count,@winner_id,@winner_amount,@alladmins,auction.creator).deliver
        end
      end
    else
      if User.find_by_username(auction.creator).email == nil
        UserMailer.administrator_notification_expired(auction.title,@alladmins,auction.creator).deliver
      else if User.find_by_username(auction.creator).email == 'on'
          UserMailer.administrator_notification_expired(auction.title,@alladmins,auction.creator).deliver
        end
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
