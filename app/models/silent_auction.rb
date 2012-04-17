class SilentAuction < ActiveRecord::Base
  validates :title,
            :presence => { :message => "Title is required" } ,
            :length => { :maximum => 255, :message => "Title is too long (Maximum 255 characters)" },
            :uniqueness => {:message => "Auction with this title already exists"}
  validates :description, :presence => { :message => "Description is required" }, :length => { :maximum => 500, :message => "Description is too long (Maximum 500 characters)" }

  scope :running, where(:open => true)
  scope :closed, where(:open => false)
end
