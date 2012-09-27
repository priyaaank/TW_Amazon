class AddRegionToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :region, :string, :default => "AUS"

  end
end
