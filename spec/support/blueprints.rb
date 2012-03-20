require 'machinist/active_record'

SilentAuctions.blueprint do
  title {Faker::Lorem.sentence}
  description {Faker::Lorem.paragraph}
end