# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

require 'simplecov'
SimpleCov.start 'rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # for devise
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

end

# Resize browser because it is responsive, and tests will fail
def resize_window
  page.driver.browser.manage.window.resize_to(1024,768)
end

def requires property
  valid_user.delete(property.to_sym)
  user = User.new(valid_user)

  user.valid?.should == false
  user[property.to_sym] = "set"
  user.valid?.should == true
end

def has_limit property, limit
  overlimit = limit + 1

  user = User.new(valid_user)
  user[property.to_sym] = "a" * overlimit
  user.valid?.should == false
  user[property.to_sym] = "a" * limit
  user.valid?.should == true
end

def redirect_to_login
  if Rails.application.config.test_mode
    response.should redirect_to(root_path)
  else
    response.should redirect_to(user_omniauth_authorize_path(:saml))
  end
end
