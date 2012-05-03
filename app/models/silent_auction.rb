class SilentAuction < ActiveRecord::Base
  before_save :strip_whitespace

  has_many :bids, :dependent => :destroy, :inverse_of => :silent_auction

  validates :title,
            :presence => { :message => "Title is required" } ,
            :length => { :maximum => 255, :message => "Title is too long (Maximum 255 characters)" },
            :uniqueness => {:message => "Duplicate title not allowed"}
  validates :description, :presence => { :message => "Description is required" }, :length => { :maximum => 500, :message => "Description is too long (Maximum 500 characters)" }

  attr_accessible :title, :description, :open

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
