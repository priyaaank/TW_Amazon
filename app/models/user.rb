class User < ActiveRecord::Base
  devise :omniauthable

  attr_accessible :username, :isAdmin

  validates :username, :presence => true, :length => { :maximum => 255 }

  def self.find_or_create_from_auth_hash(auth_hash, signed_in_resource=nil)
    return nil unless defined? auth_hash[:uid]
    return nil if auth_hash[:uid].blank?

    user = User.where(:username => auth_hash[:uid])

    return user.first unless user.empty?

    User.create!(:username => auth_hash[:uid], :isAdmin => self.is_admin?(auth_hash[:uid]))
  end

  def valid_password?(password)
    true
  end

  def self.is_admin?(uid)
    admins = ["dgower", "rwijekoo"]
    if admins.include?(uid)
      true
    else
      false
    end
  end
end
