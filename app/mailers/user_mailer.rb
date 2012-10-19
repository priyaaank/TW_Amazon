class UserMailer < ActionMailer::Base
  
  def winner_notification(title,bids_count,winner_id,winner_amount,creator)
    @creator = creator
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    @recipients =  "#{@winner_id}"
    mail(:to => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] [Testing ONLY] Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  
  def administrator_notification_close(title,bids_count,winner_id,winner_amount,alladmins,creator)
    @creator = creator
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    @recipients = "#{@creator}@thoughtworks.com"
    #@recipients = "twgs.twgs@gmail.com"
    mail(:to => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] [Testing ONLY] Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')    
  end

  def administrator_notification_expired(title,alladmins,creator)
    @creator = creator
    @title = title
    @recipients = "#{@creator}@thoughtworks.com"
    #@recipients = "twgs.twgs@gmail.com"
    mail(:to => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] [Testing ONLY] Auction for \"#{@title}\" has expired", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  
  def send_announcement_to_other_users(auction)
    @title = auction.title
    @start_date = auction.start_date.strftime("%d %B %Y")
    @end_date = auction.end_date.strftime("%d %B %Y")
    #@other_users = User.where("username <> ? AND region = ?", auction.creator, auction.region)
    @all_recipients = "twgs.twgs@gmail.com"
    # @other_users.each do |user|
      # if @all_recipients != "" then 
        # @all_recipients = @all_recipients + ", "
      # end
      # if user.email == nil
        # @all_recipients = @all_recipients + user.username + "@thoughtworks.com"
        # else if user.email == 'on'
          # @all_recipients = @all_recipients + user.username + "@thoughtworks.com"
        # end                  
      # end
    # end

    # send the email only when there is at least 1 recipient
    mail(:to => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] [Testing ONLY] New auction for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')      
  end
  
  def seller_notification_quick_sale_almost_ends(title,creator)
    @creator = creator
    @title = title
    @recipients = "#{@creator}@thoughtworks.com"
    #@recipients = "twgs.twgs@gmail.com"
    mail(:to => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] [Testing ONLY] Your sale of item \"#{@title}\" is about to end", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
end