class UserMailer < ActionMailer::Base
  #default :from => "the_ghost@email.com"
  
  def winner_notification(title,bids_count,winner_id,winner_amount)
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    @recipients =  "#{@winner_id}"
    mail(:to => "#{@recipients}", :subject => "Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  
  def administrator_notification_close(title,bids_count,winner_id,winner_amount,alladmins)
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    #@recipients = "twamazon@thoughtworks.com, dgower@thoughtworks.com"
    @recipients = "twgs.twgs@gmail.com"
    #@recipients = alladmins
    #mail(:to => "peter.aryanto@gmail.com, #{@winner_id}", :subject => "The winning bid for \"#{@title}\"", :from => 'the_ghost@your_home.com')
    mail(:to => "#{@recipients}", :subject => "Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')    
  end

  def administrator_notification_expired(title,alladmins)
    @title = title
    @recipients = "twgs.twgs@gmail.com"
    #@recipients = alladmins
    #mail(:to => "peter.aryanto@gmail.com, #{@winner_id}", :subject => "The winning bid for \"#{@title}\"", :from => 'the_ghost@your_home.com')
    mail(:to => "#{@recipients}", :subject => "Auction for \"#{@title}\" has expired", :from => 'GarageSale@no-reply.thoughtworks.com')
    #mail(:to => "#{@alladmins}", :subject => "Auction for \"#{@title}\" has expired -- \">>>#{@alladmins}<<<\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
end