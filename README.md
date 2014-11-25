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
- ruby-install ruby 2.0

Installing Gems (via Bundler)
- gem install bundler
- bundle install

If you have problems installing any of the gems in Bundler, you may be running the wrong version of Ruby.
Try running `chruby 2` to switch to the more recent version.

To start the server:
- rails s

View the app locally:
- http://localhost:3000

To make chruby work, do:
vim ~/.bash_profile
Then add:   source /usr/local/share/chruby/chruby.sh
	    source /usr/local/share/chruby/auto.sh
			  

Before doing “gem install bundler”,
go to the project directory.
otherwise the gem won’t be installed.


When doing “gem install bundler”,
if “gem install pg” goes wrong, try:

/*The first thing you should do is ensure that the 'pg_config' tool that comes with Postgres is in your path. If it isn't, or the one that's first in your path isn't the one that was installed with the Postgres you want to build against, you can specify the path to it with the --with-pg-config option.

For example, if you're using the Ruby binary that comes with OSX, and PostgreSQL 9.3 installed from MacPorts, do:*/

gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config



Database
- rake db:migrate
- rake db:seed
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

