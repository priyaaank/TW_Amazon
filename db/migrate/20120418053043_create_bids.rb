class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.float :amount
      t.boolean :active, :default => true
      t.integer :silent_auction_id
      t.integer :user_id
      t.timestamps
    end
    add_index :bids, :user_id
    add_index :bids, :silent_auction_id
  end
end
