require 'machinist/active_record'

SilentAuction.blueprint do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
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

Bid.blueprint do
  # Attributes here
end
