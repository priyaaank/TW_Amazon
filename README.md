ThoughtWorks Garage Sale


Development environment
-----------------------

Ruby Version:
- Install Ruby 2.0
- Make sure that you are using Ruby 2.0
- Check using - which ruby
- Switch using - chruby 2.0

Installing Ruby (via Homebrew & Chruby)
- brew install chruby
- brew install ruby-install
- ruby-install ruby 1.9.3
- ruby-install ruby 2.0

Installing Gems (via Bundler)
- gem install bundler
- bundle install

To start the server:
- rails s

Database
- The local database is a SQLite database
- Install a database tool e.g. - DbVisualizer
- Database URL - jdbc:sqlite:/Users/[username]/Development/TW_Amazon/db/development.sqlite3

Test users are created by default. Use the following passwords to login
- 'adminpass' - for admin users
- 'userpass'  - for normal users

Testing emails in development/test environments:
- Run 'gem install mailcatcher' to install mailcatcher
- Run 'mailcatcher' to start the mail catcher
- Access the emails @ http://localhost:1080


Adding Git link to Heroku
--------------------------
- git remote add production git@heroku.com:twgs.git
- heroku config:set RACK_ENV=staging RAILS_ENV=staging --remote staging
- git remote add staging git@heroku.com:twgs-staging.git

Deploying to Heroku
--------------------
- To Staging:  git push staging master
- To Prod:     git push production master

