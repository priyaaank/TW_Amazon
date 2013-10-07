ThoughtWorks Garage Sale


Development environment
-----------------------

To start the server:
- bundle install
- rails s

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
- git remote add staging git@heroku.com:twgs-staging.git

Deploying to Heroku
--------------------
- To Staging:  git push staging master
- To Prod:     git push production master

