class SilentAuction < ActiveRecord::Base
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
end
