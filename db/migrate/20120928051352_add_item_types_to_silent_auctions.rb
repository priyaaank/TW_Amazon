class AddItemTypesToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :item_type, :string, :default => "Silent Auction"

  end
end
