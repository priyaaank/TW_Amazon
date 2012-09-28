module SilentAuctionsHelper

  # return bid user has placed for the provided auction
  def user_bid_for_auction(auction)
    bid = current_user.bids.where(:silent_auction_id => auction.id).first
  end

  # return winner name
  def won_bid_for_auction(auction)
    winBid = auction.bids.active.highFirst.earlier.first
  end

  def formatted_date(date)
    date.to_s(:day_date_and_month)
  end

  def get_region_config(region)
    yaml = get_regions
    yaml[region]
  end
  
  def get_regions
    config_file = "#{Rails.root}/config/region.yml"
    YAML.load_file(config_file)    
  end
  
  def get_categories
    config_file = "#{Rails.root}/config/category.yml"
    categories = YAML.load_file(config_file)
  end
  # def ensure_user_has_a_region
    # unless current_user.region
      # new_region_user_path(current_user)
    # else
      # index_path
    # end
  # end    
end