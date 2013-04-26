class CreateAuctionMessages < ActiveRecord::Migration
  def change
    create_table :auction_messages do |t|
      t.integer :silent_auction_id
      t.text :message
      t.string :creator
      t.timestamps :message_date

      t.timestamps
    end
  end
end
