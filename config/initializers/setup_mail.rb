ActionMailer::Base.sendmail_settings = {
  :address        => "smtp.gmail.com",
  :port           => "587",
  #:domain         => "twgs.herokuapp.com",
  #:domain         => "gmail.com",
  :user_name      => "twamazon@thoughtworks.com",
  :password       => "TWp@55word!",
  :authentication => :plain,
  :enable_startttls_auto => true
}
