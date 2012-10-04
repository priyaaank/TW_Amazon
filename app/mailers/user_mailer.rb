class UserMailer < ActionMailer::Base
  #default :from => "the_ghost@email.com"
  
  def winner_notification(title,bids_count,winner_id,winner_amount,creator)
    @creator = creator
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
  
  def send_announcement_to_other_users(auction)
    #@creator = auction.creator;
    @title = auction.title
    @start_date = auction.start_date.strftime("%d %B %Y")
    @end_date = auction.end_date.strftime("%d %B %Y")
    @other_users = User.where("username <> ? AND region = ?", auction.creator, auction.region)
    @all_recipients = ""
    @other_users.each do |user|
      if @all_recipients != "" then 
        @all_recipients = @all_recipients + ", "
      end
      @all_recipients = @all_recipients + user.username + "@thoughtworks.com"
    end
    mail(:to => "#{@all_recipients}", :subject => "[TW Garage Sale] New auction for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
end