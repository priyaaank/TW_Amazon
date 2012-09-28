TWAmazon::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  #config.action_mailer.default_url_options = { host: "twgs.herokuapp.com" }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.mandrillapp.com",
    :port                 => "587",
    :domain               => "mandrillapp.com",
    :user_name            => "app6942104@heroku.com",
    :password             => "3bc71a78-915d-4be0-9a84-2c1d135c4c49",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
  # ActionMailer::Base.smtp_settings = {
    # :address              => "smtp.gmail.com",
    # :port                 => "587",
    # :domain               => "gmail.com",
    # :user_name            => "twgs.twgs@gmail.com",
    # :password             => "twgs.twgs",
    # :authentication       => "plain",
    # :enable_starttls_auto => true
  # }

  #config.action_mailer.sendmail_settings = { :arguments => '-i' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # for devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }


end
