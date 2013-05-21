require 'machinist/active_record'

SilentAuction.blueprint do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  min_price { 1.00 }
  end_date { 7.days.from_now }
  region {Region.make!(:aus)}
  category {Category.make!(:laptops)}
  start_date { Time.zone.now.in_time_zone(Region.make!(:aus).timezone) + 10.minutes}
end

User.blueprint do
  username  { "user-#{sn}" }
  admin { false }
  password {"userpass"}
  password_confirmation {"userpass"}
  region {Region.make!(:aus)}
end

User.blueprint(:user) do
  username  { "user-#{sn}" }
  admin { false }
  password {"userpass"}
  password_confirmation {"userpass"}
end

User.blueprint(:admin) do
  username  { "admin-#{sn}" }
  admin { true }
  password {"adminpass"}
  password_confirmation {"adminpass"}
end

User.blueprint(:casUser) do
  username  { "casUser-#{sn}" }
  admin { false }
  password { nil }
  password_confirmation {nil}
end

Bid.blueprint do
end

Photo.blueprint do
  # Attributes here
end

Region.blueprint(:aus) do
  code {'AUS'}
  currency {'AU$'}
  timezone {'Melbourne'}
  maximum {10000}
end

Region.blueprint(:ind) do
  code {'IND'}
  currency {'Rs'}
  timezone {'New Delhi'}
  maximum {100000}
end

AdminUser.blueprint do
  # Attributes here
end

AuctionMessage.blueprint do
  # Attributes here
end

Category.blueprint(:laptops) do
  category {'Laptops'}
end

EmailNotification.blueprint do
  # Attributes here
end
