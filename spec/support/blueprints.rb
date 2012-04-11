require 'machinist/active_record'

SilentAuction.blueprint do
  title {Faker::Lorem.sentence}
  description {Faker::Lorem.paragraph}
end

User.blueprint(:user) do
  name  { Faker::Internet.user_name }
  isAdmin {false}
end

User.blueprint(:admin) do
  name  { Faker::Internet.user_name }
  isAdmin { true }
end