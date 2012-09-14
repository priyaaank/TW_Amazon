desc "Perform closing auctions that has passed their end date"
task :close_auction_ending_today => :environment do
  puts "Closing ended auctions..."
  SilentAuction.close_auctions_ending_today
  puts "done."
end
