class SilentAuction < ActiveRecord::Base
  before_validation :strip_whitespace
  before_save :strip_whitespace
  before_save :set_default_region
  before_save :validate_price_limit

  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction
  has_many :photos, :dependent => :destroy, :inverse_of => :silent_auction
  has_many :auction_messages, :dependent => :destroy, :inverse_of => :silent_auction
  belongs_to :region
  belongs_to :category
  delegate :currency, :timezone, :to => :region

  attr_accessible :title, :description, :open, :min_price, :start_date, :end_date, :photos_attributes, :category_id, :creator, :item_type, :as  => [:default, :admin]
  attr_accessible :region_id, :as => :admin
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? && attributes['image_cache'].blank? && attributes['caption'].blank? }

  validates :title, :presence => { :message => "Title is required" } ,
    :length => { :maximum => 255, :message => "Title is too long (Maximum 255 characters)" },
    :uniqueness => { :message => "Duplicate title not allowed"}

  validates :description, :presence => { :message => "Description is required" },
    :length => { :maximum => 500, :message => "Description is too long (Maximum 500 characters)" }

  validates :min_price, :presence => { :message => "is required"},
    :numericality => { :greater_than_or_equal_to => 0.01},
    :format => { :with => /^\d+?(?:\.\d{0,2})?$/, :message => "can only have 2 decimal places" }

  validates :start_date, :presence => {:message => "Start date is required"}
  validate :check_start_date, :on => :create, :unless => "start_date.nil?"
  validates :end_date, :presence => {:message => "End date is required"}
  validates_datetime :end_date, :on_or_after => :start_date
  validates :end_date, :timeliness => {:on_or_before => lambda{|auction| auction.start_date + 2.months}, :type => :date}
  validates :category_id, :presence => { :message => "Please select a category" }

  def self.query_running_auctions_of_type(auction_type)
    Proc.new { |timezone| where(["start_date < :today AND open = :is_open AND item_type = '#{auction_type}'", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true]) }
  end

  scope :running, lambda { |timezone| where(["start_date < :today AND open = :is_open", :today => Time.zone.now.in_time_zone(timezone).to_date + 1.day, :is_open => true]) }
  scope :running_silent_auction, query_running_auctions_of_type('Silent Auction')
  scope :running_normal_auction, query_running_auctions_of_type('Normal Auction')
  scope :running_quick_sales, query_running_auctions_of_type('Quick Sale')
  scope :future, lambda { |timezone| where("start_date > ? AND open = ? AND (item_type = 'Silent Auction' OR item_type = 'Normal Auction')", Time.zone.now.in_time_zone(timezone).to_date, true) }
  scope :future_sale, lambda { |timezone| where("start_date > ? AND open = ? AND item_type = 'Quick Sale'", Time.zone.now.in_time_zone(timezone).to_date, true) }
  scope :closed, includes(:bids).where("bids.id IS NOT NULL AND bids.active = ? AND open = ?", true, false)
  scope :expired, includes(:bids).where("silent_auctions.open = ? AND silent_auctions.id NOT IN (select distinct silent_auction_id from bids where active = ?)", false, true)
  scope :recent, order('"silent_auctions"."created_at" desc')
  scope :ending_today, lambda { |timezone| where("end_date <= ?", (Time.zone.now.in_time_zone(timezone) + 10.minutes).to_date ) }

  def initialize(*params)
    super(*params)
  end

  def check_start_date
    errors.add(:start_date, "Start date must be on or after #{date_today}") unless self.start_date.to_date >= date_today
  end

  def strip_whitespace
    title = title.strip unless title.nil?
    description = description.strip unless description.nil?
  end

  def validate_price_limit
    maximum = region.maximum.to_f
    currency = region.currency
    valid = min_price < maximum
    errors.add(:min_price, " can't exceed #{currency} #{number_with_delimiter(maximum, :delimiter => ',')}") unless valid
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

    defaults = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
    options = options.reverse_merge(defaults)

    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
    parts.join(options[:separator]).html_safe
  end

  def set_default_region
    region = Region.find_by_code("AUS") if region.nil?
  end

  def close
    if bids.active.count == 0 && self.item_type != 'Silent Auction'
      errors.add :message, "Auction with no active bid cannot be closed"
      false
    else
      change_to_closed
      true
    end
  end

  def has_active_bid
    bids.active.count > 0
  end

  def change_to_closed
    if item_type == 'Quick Sale'
      destroy
    else
      self.open = false
      save!
      self.send_notification_email(self) unless Rails.application.config.test_mode
    end
  end

  def self.close_auctions_ending_today
    self.find_all_by_open(true).each do |auction|
      timezone = auction.timezone
      if auction.end_date < (Time.zone.now.in_time_zone(timezone) + 10.minutes).to_date
        auction.change_to_closed
      end
      current_time = Time.zone.now.in_time_zone(timezone) + 10.minutes

      # to send email notification to the item's owner 2 days before a sale ends
      if current_time.hour == 0 && auction.end_date == (current_time.to_date + 2.days)
        @silent_auction = auction
        if auction.item_type == 'Quick Sale'
          UserMailer.seller_notification_quick_sale_almost_ends(@silent_auction.title,@silent_auction.creator).deliver unless Rails.application.config.test_mode
        else
          @bids=Bid.find_by_silent_auction_id(@silent_auction.id);
          @bids.each do |bid|
            if @all_recipients != "" then
              @all_recipients = @all_recipients + ", "
            end
            @email_notification=EmailNotification.find_by_users_id(bid.user_id)
            if bid.user_id !=@silent_auction.creator
              if @email_notification != nil
                if @email_notification.item_ending
                  @all_recipients = @all_recipients + user.username + "@thoughtworks.com"
                end
              end
            end
          end
          UserMailer.buyer_notification_auction_almost_ends(@silent_auction.title,@all_recipients).deliver
        end
      end
      # to send email notification when the auction of an item STARTS
      if current_time.hour == 0 && auction.start_date == current_time.to_date
        @silent_auction = auction
        UserMailer.send_announcement_to_other_users(@silent_auction).deliver unless Rails.application.config.test_mode
      end
    end
  end

  def send_notification_email(auction)
    @winner_id = ""
    @winner_amount = ""
    @winnerOrder = Bid.where("silent_auction_id = ? AND active = ?",auction.id,true)
    @count = @winnerOrder.count
    @admins = User.where("admin = ? AND region_id = ?", true, auction.region)
    @alladmins = @admins.collect{|admin| admin.username + '@thoughtworks.com'}.join(',')
    if @count > 0
      @winner = @winnerOrder.order("amount ASC").last!
      @winner_id = User.find(@winner.user_id).username + "@thoughtworks.com"
      @winner_amount = region.currency + " " + number_with_delimiter(@winner.amount)
      UserMailer.winner_notification(auction.title,@count,@winner_id,@winner_amount,auction.creator).deliver
      UserMailer.administrator_notification_close(auction.title,@count,@winner_id,@winner_amount,@alladmins,auction.creator).deliver
      # item not win
      @winnerOrder.each do |bid|
        if @all_recipients != "" then
          @all_recipients = @all_recipients + ", "
        end
        if bid.user_id!=User.find(@winner.user_id)
          @email_notification=EmailNotification.find_by_users_id(bid.user_id)
          if @email_notification != nil
            if @email_notification.item_not_win
              @all_recipients = @all_recipients + user.username + "@thoughtworks.com"
            end
          end
        end
      end
      UserMailer.item_not_win(auction.title,@all_recipients).deliver
    else
      @email_notification=EmailNotification.find_by_users_id(User.find_by_username(auction.creator).id)
      if @email_notification != nil
        if @email_notification.item_not_sell
          UserMailer.administrator_notification_expired(auction.title,@alladmins,auction.creator).deliver
        end
      end
    end
  end

  private
  def date_today
    Time.zone.now.in_time_zone(timezone).to_date
  end

end
