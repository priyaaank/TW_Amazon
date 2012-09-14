require 'machinist/active_record'

SilentAuction.blueprint do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  min_price { 1.00 }
  start_date { Date.today }
end

User.blueprint do
  username  { "user-#{sn}" }
  admin { false }
  password {"userpass"}
  password_confirmation {"userpass"}
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
  # Attributes here
end

Photo.blueprint do
  # Attributes here
end
