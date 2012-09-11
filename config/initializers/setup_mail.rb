ActionMailer::Base.smtp_settings = {
  :address        => "smtp.gmail.com",
  :port           => "587",
  :domain         => "twgs.herokuapp.com",
  :user_name      => "twamazon@thoughtworks.com",
  :password       => "TWp@55word!",
  :authentication => "plain",
  :enable_startttls_auto => true
}
