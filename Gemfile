source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'jquery-rails'

#CAS OAUTH gems
gem 'devise'
gem 'omniauth-cas'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  # UI gems
  gem "less-rails"
  gem 'simple_form'
  gem "haml"
  gem "haml-rails"
  gem "twitter-bootstrap-rails"
end

group :production, :staging do
  gem "pg"
end

group :development, :test do
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'awesome_print'
  gem 'machinist'
  gem 'faker'
  gem 'blueprints'
  gem 'sqlite3'

end

