class User < ActiveRecord::Base
  has_many :bids, :inverse_of => :user
  belongs_to :region

  devise :omniauthable
  attr_accessible :username, :admin, :email, :as => [:default, :admin]
  validates :username, :presence => true, :length => { :maximum => 255 }

  # for dummy users
  devise :database_authenticatable
  attr_accessible :email, :password, :password_confirmation, :as => :default
  attr_accessible :region_id, :encrypted_password, :as => :admin
  delegate :timezone, :currency,  :to => :region

  # Devise method used to create user from CAS uid
  def self.find_or_create_from_auth_hash(auth_hash, signed_in_resource=nil)
    return nil unless defined? auth_hash[:uid]
    return nil if auth_hash[:uid].blank?

    user = User.where(:username => auth_hash[:uid])

    return user.first unless user.empty?

    User.create!(:username => auth_hash[:uid], :admin => self.is_admin?(auth_hash[:uid]))
  end

  def self.is_admin?(uid)
    ["dgower", "prtan", "twamazon", "venkatn"].include?(uid)
  end

  def is_admin?
    admin
  end

  def region_id
    region.id if !region.nil?
  end

end
