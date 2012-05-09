source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'jquery-rails'
gem 'coffee-rails', '~> 3.2.1'
gem "heroku"

#CAS OAUTH gems
gem 'devise'
gem 'omniauth-cas'
gem 'simple_form'
gem "haml"
gem "haml-rails"
gem "twitter-bootstrap-rails"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
  gem "less-rails"
  gem "therubyracer"
end

group :production, :staging do
  gem "pg"
  gem 'thin'
  gem 'rufus-scheduler'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'simplecov'
  gem 'capybara'
  gem 'awesome_print'
  gem 'machinist'
  gem 'faker'
  gem 'blueprints'
end

