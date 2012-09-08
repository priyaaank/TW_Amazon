ActionMailer::Base.smtp_settings = {
  :address        => "smtp.gmail.com",
  :port           => "587",
  :domain         => "twgsx.herokuapp.com",
  :user_name      => "peter.aryanto@gmail.com",
  :password       => "Hibik180",
  :authentication => "plain",
  :enable_startttls_auto => true
}
