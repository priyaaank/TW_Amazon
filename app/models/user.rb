class User < ActiveRecord::Base
  has_many :bids, :inverse_of => :user

  devise :omniauthable
  attr_accessible :username, :admin, :region, :email
  validates :username, :presence => true, :length => { :maximum => 255 }

  # for dummy users
  devise :database_authenticatable
  attr_accessible :email, :password, :password_confirmation

  # Devise method used to create user from CAS uid
  def self.find_or_create_from_auth_hash(auth_hash, signed_in_resource=nil)
    return nil unless defined? auth_hash[:uid]
    return nil if auth_hash[:uid].blank?

    user = User.where(:username => auth_hash[:uid])

    return user.first unless user.empty?

    User.create!(:username => auth_hash[:uid], :admin => self.is_admin?(auth_hash[:uid]), :email => 'on')
  end

  def self.is_admin?(uid)
    admins = ["dgower", "prtan", "twamazon", "venkatns"]
    if admins.include?(uid)
      true
    else
      false
    end
  end
end
