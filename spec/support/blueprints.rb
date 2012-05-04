require 'machinist/active_record'

SilentAuction.blueprint do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  min_price { 1.00 }
end

User.blueprint(:user) do
  username  { Faker::Internet.user_name }
  admin { false }
  password {"userpass"}
  password_confirmation {"userpass"}
end

User.blueprint(:admin) do
  username  { Faker::Internet.user_name }
  admin { true }
  password {"adminpass"}
  password_confirmation {"adminpass"}
end

User.blueprint(:casUser) do
  username  { Faker::Internet.user_name }
  admin { false }
  password { nil }
  password_confirmation {nil}
end

Bid.blueprint do
  # Attributes here
end
