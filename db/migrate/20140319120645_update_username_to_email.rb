class UpdateUsernameToEmail < ActiveRecord::Migration
  def up
    User.where("username NOT LIKE '%@thoughtworks.com'").each do |user|
      user.username += '@thoughtworks.com'
      user.save!
    end
  end

  def down
    User.where("username LIKE '%@thoughtworks.com'").each do |user|
      user.username = user.username.gsub('@thoughtworks.com','')
      user.save!
    end
  end
end
