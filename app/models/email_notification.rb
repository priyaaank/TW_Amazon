class EmailNotification < ActiveRecord::Base
  attr_accessible :auction_messages_by_creator, :auction_messages_by_other, :creator_auction_messages, :item_ending, :item_not_sell, :item_not_win, :item_outbid, :item_will_sell, :item_won, :new_items, :new_items_category, :users_id, :auction_starts
  attr_accessor :select_all
end
