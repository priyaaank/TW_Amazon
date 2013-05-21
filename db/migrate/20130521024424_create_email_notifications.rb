class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.integer :users_id
      t.boolean :item_ending
      t.boolean :item_won
      t.boolean :item_will_sell
      t.boolean :item_not_sell
      t.boolean :item_not_win
      t.boolean :auction_messages_by_creator
      t.boolean :auction_messages_by_other
      t.boolean :creator_auction_messages
      t.boolean :new_items
      t.integer :new_items_category
      t.boolean :item_outbid
      t.boolean :all_email_notification

      t.timestamps
    end
  end
end
