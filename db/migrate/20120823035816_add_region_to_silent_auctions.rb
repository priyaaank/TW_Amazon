class AddRegionToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :region, :string, :default => "au"

  end
end
