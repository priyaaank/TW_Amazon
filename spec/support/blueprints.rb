require 'machinist/active_record'

SilentAuction.blueprint do
  title {Faker::Lorem.sentence}
  description {Faker::Lorem.paragraph}
end