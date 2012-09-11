class UserMailer < ActionMailer::Base
  #default :from => "the_ghost@email.com"
  def registration_confirmation0(title,bids_count,winner_id,winner_amount)
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    #@recipients = "twamazon@thoughtworks.com, dgower@thoughtworks.com"
    @recipients = "twamazon@thoughtworks.com"
    #@recipients = "peter.aryanto@gmail.com"
    if @winner_id != ""
      @recipients = @recipients + ", #{@winner_id}"
    end
    #mail(:to => "peter.aryanto@gmail.com, #{@winner_id}", :subject => "The winning bid for \"#{@title}\"", :from => 'the_ghost@your_home.com')
    mail(:to => "#{@recipients}", :subject => "The winning bid for \"#{@title}\"", :from => 'twamazon@thoughtworks.com')
  end
  
=begin  
  def send
    UserMailer.registration_confirmation.deliver
  end
=end

  def registration_confirmation(title,bids_count,winner_id,winner_amount)
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    #@recipients = "twamazon@thoughtworks.com, dgower@thoughtworks.com"
    @recipients = "twamazon@thoughtworks.com"
    #@recipients = "peter.aryanto@gmail.com"
    if @winner_id != ""
      @recipients = @recipients + ", #{@winner_id}"
    end
    @add = ""
    if (@bids_count > 0)
      @add = " and the winner is #{@winner_id} with the bid amount of #{@winner_amount}."
    end
    msg = <<END_OF_MESSAGE
      From: twamazon@thoughtworks.com
      To: "#{@recipients}"
      Subject: "The winning bid for \"#{@title}\""
      TW Garage Sale reporting in...   :)
      
      
      The auction "<%= @title %>" has ended.
      We have got <%= @bids_count %> bidder(s) <%= @add %> 


      Kind regards,
      TW Garage Sale
    END_OF_MESSAGE
    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message msg, from, to
    end
  end


end