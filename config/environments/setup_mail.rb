ActionMailer::Base.sendmail_settings = {
  :address        => "smtp.gmail.com",
  :port           => "587",
  #:domain         => "twgs.herokuapp.com",
  :domain         => "www.thoughtworks.com",#gmail.com",
  :user_name      => "twamazon@thoughtworks.com",#twgs.twgs@gmail.com",
  :password       => "TWp@55word!",#twgs.twgs",
  :authentication => "plain",
  :enable_startttls_auto => true
}
