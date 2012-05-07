class SilentAuction < ActiveRecord::Base
  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction

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
  scope :closed, where(:open => false)
  scope :recent, order('created_at desc')

  after_initialize :set_attr

  def set_attr
    self.end_date = 2.weeks.from_now.to_formatted_s(:day_date_and_month)
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
end
