class RemoveEmailNotificationsFromUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    attr_accessible :email
  end


  def up
    # User.where("email is 'on'").each do |user|
    all_users = User.all
    all_users.each do |user|
    if user.email == 'on'
    EmailNotification.create(:users_id => user.id, :item_ending => true,
     :item_will_sell => true,
     :item_not_sell => true,
     :item_not_win => true,
     :auction_messages_by_creator => true,
     :auction_messages_by_other => true,
     :creator_auction_messages => true,
     :new_items => true,
     :new_items_category => "0",
     :auction_starts => true)
    elsif user.email == nil || user.email == ''
      EmailNotification.create(:users_id => user.id, :item_ending => true,
      :item_will_sell => true,
      :item_not_sell => true,
      :item_not_win => true,
      :auction_messages_by_creator => true,
      :auction_messages_by_other => true,
      :creator_auction_messages => true,
      :new_items => true,
      :new_items_category => "0",
          :auction_starts => true)
     elsif user.email == 'off'
       EmailNotification.create(:users_id => user.id, :item_ending => false,
      :item_will_sell => false,
      :item_not_sell => false,
      :item_not_win => false,
      :auction_messages_by_creator => false,
      :auction_messages_by_other => false,
      :creator_auction_messages => false,
      :new_items => false,
      :new_items_category => '-1',
      :auction_starts => false)
     end
    end
    remove_column :users, :email
  end

  def down
    add_column :users, :email, :string , :null => true, :default => nil
      EmailNotification.all do |email_settings|
        if email_settings.new_items_category == '0'
         user = User.find("id is #{email_settings.users_id}")
         user.email = "on"
          user.save
        elsif email_settings.new_items_category == '-1'
          user = User.find("id is #{email_settings.users_id}")
          user.email = "off"
          user.save
        end
        email_settings.destroy
      end

  end
end
