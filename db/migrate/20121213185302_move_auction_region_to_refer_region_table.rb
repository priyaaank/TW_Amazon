class MoveAuctionRegionToReferRegionTable < ActiveRecord::Migration
  class SilentAuction < ActiveRecord::Base
     attr_accessible  :region, :region_code
     belongs_to :region
   end

  def up
    rename_column :silent_auctions, :region, :region_code
    add_column :silent_auctions, :region_id, :integer, :references  => "regions", :null => true
    SilentAuction.where("region_code is not null").each {|silent_auction|
      silent_auction.region = Region.find_by_code(silent_auction.region_code)
      silent_auction.save!
    }
    remove_column :silent_auctions, :region_code
  end

  def down
    add_column :silent_auctions, :region_code, :string
    SilentAuction.where("region_id is not null").each {|silent_auction|
      silent_auction.region_code = silent_auction.region.code
      silent_auction.save!
    }
    remove_column :silent_auctions, :region_id
    rename_column :silent_auctions, :region_code, :region
  end

end
