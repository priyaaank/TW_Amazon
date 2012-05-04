class AddPriceToSilentAuction < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :min_price, :float

  end
end
