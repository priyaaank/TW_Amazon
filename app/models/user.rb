class User < ActiveRecord::Base
  devise :omniauthable, :database_authenticatable

         attr_accessible :username, :admin

  #set accessible for test accounts
  attr_accessible :email, :password, :password_confirmation

  validates :username, :presence => true, :length => { :maximum => 255 }

  # Devise method used to create user from CAS uid
  def self.find_or_create_from_auth_hash(auth_hash, signed_in_resource=nil)
    return nil unless defined? auth_hash[:uid]
    return nil if auth_hash[:uid].blank?

    user = User.where(:username => auth_hash[:uid])

    return user.first unless user.empty?

    User.create!(:username => auth_hash[:uid], :admin => self.is_admin?(auth_hash[:uid]))
  end

  def self.is_admin?(uid)
    admins = ["dgower", "twamazon"]
    if admins.include?(uid)
      true
    else
      false
    end
  end

  def valid_password?(password)
    true
  end


end
