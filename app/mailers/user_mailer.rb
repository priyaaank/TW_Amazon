class UserMailer < ActionMailer::Base
  #default :from => "the_ghost@email.com"
  def registration_confirmation(title,bids_count,winner_id,winner_amount)
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    #@recipients = "twamazon@thoughtworks.com, dgower@thoughtworks.com"
    @recipients = "twamazon@thoughtworks.com"
    if @winner_id != ""
      @recipients = @recipients + ", #{@winner_id}"
    end
    #mail(:to => "peter.aryanto@gmail.com, #{@winner_id}", :subject => "The winning bid for \"#{@title}\"", :from => 'the_ghost@your_home.com')
    mail(:to => "#{@recipients}", :subject => "The winning bid for \"#{@title}\"", :from => 'the_ghost@your_home.com')
  end
=begin  
  def send
    UserMailer.registration_confirmation.deliver
  end
=end
end