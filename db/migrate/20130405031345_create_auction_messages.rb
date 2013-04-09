class CreateAuctionMessages < ActiveRecord::Migration
  def up
    create_table :auction_messages do |t|
      t.integer  :silent_auction_id
      t.text  :message
      t.string    :creator
      t.integer   :user_id
      t.timestamps
    end
    add_index     :auction_messages, [:silent_auction_id]
  end
end
