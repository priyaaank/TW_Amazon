class SilentAuction < ActiveRecord::Base
  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction

  attr_accessible :title, :description, :open, :min_price
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

  def strip_whitespace
    self.title = self.title.strip
  end

  def close
    if self.bids.active.count == 0
      errors.add :base, "Auction with no active bid cannot be closed"
      false
    else
      self.open = false
      self.save!
      true
    end
  end
end
