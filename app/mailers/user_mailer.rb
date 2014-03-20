class UserMailer < ActionMailer::Base

  def winner_notification(title,bids_count,winner_id,winner_amount,creator)
    @creator = creator
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    @recipients =  "#{@winner_id}"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end

  def administrator_notification_close(title,bids_count,winner_id,winner_amount,alladmins,creator)
    @creator = creator
    @title = title
    @bids_count = bids_count
    @winner_id = winner_id
    @winner_amount = winner_amount
    @recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Auction results for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end

  def administrator_notification_expired(title,alladmins,creator)
    @creator = creator
    @title = title
    @recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Auction for \"#{@title}\" has expired", :from => 'GarageSale@no-reply.thoughtworks.com')
  end

  def send_announcement_to_other_users(auction)
    @title = auction.title

    @url = silent_auctions_url
    if auction.item_type == 'Quick Sale'
      @url = sales_silent_auctions_url
    elsif auction.item_type == 'Normal Auction'
      @url = normal_auctions_silent_auctions_url
    end

    @start_date = auction.start_date.strftime("%d %B %Y")
    @end_date = auction.end_date.strftime("%d %B %Y")
    @other_users = User.where("username <> ? AND region_id = ?", auction.creator, auction.region)
    @all_recipients = "twgs.twgs@gmail.com"
    @other_users.each do |user|
      if @all_recipients != "" then
        @all_recipients = @all_recipients + ", "
      end
      @email_notification=EmailNotification.find_by_users_id(user.id)
      if @email_notification != nil
        if @email_notification.auction_starts
          @all_recipients = @all_recipients + user.username
        end
      end
    end

    # send the email only when there is at least 1 recipient
    mail(:bcc => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] New auction for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end

  def seller_notification_quick_sale_almost_ends(title,creator)
    @creator = creator
    @title = title
    @recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Your sale of item \"#{@title}\" is about to end", :from => 'GarageSale@no-reply.thoughtworks.com')
  end

  def item_outbid(title,outBidder)
    @outBidder = outBidder
    @title = title
    @recipients = @outBidder
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Your bid for auction \"#{@title}\" has been outbid", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def item_withdraw(title,highestBidder)
    @highestBidder = highestBidder
    @title = title
    @recipients = @highestBidder
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Your bid for auction \"#{@title}\" is the highest bid for the auction", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def item_not_win(title,recipients)
    @recipients = recipients
    @title = title
    #@recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] You didn't win bid of item \"#{@title}\" ", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def item_will_sell(title,creator)
    @creator = creator
    @title = title
    @recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Congratulations Your item \"#{@title}\" will surely sell", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def buyer_notification_auction_almost_ends(title,recipients)
    @recipients = recipients
    @title = title
    #@recipients = @creator
    #@recipients = "twgs.twgs@gmail.com"
    mail(:bcc => "#{@recipients}", :subject => "[TW Garage Sale] [SPAM] Your chance to buy item \"#{@title}\" is about to end", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def send_announcement_to_other_users_now(auction)
    @title = auction.title

    @type = ''
    if auction.item_type == 'Quick Sale'
      @type = '/sales'
    else if auction.item_type == 'Normal Auction'
      @type = '/normal_auctions'
    end # end of else if
    end

    @start_date = auction.start_date.strftime("%d %B %Y")
    @end_date = auction.end_date.strftime("%d %B %Y")
    @other_users = User.where("username <> ? AND region_id = ?", auction.creator, auction.region)
    @all_recipients = "twgs.twgs@gmail.com"
    @other_users.each do |user|
      if @all_recipients != "" then
        @all_recipients = @all_recipients + ", "
      end
      @email_notification=EmailNotification.find_by_users_id(user.id)
      if @email_notification != nil
        if @email_notification.new_items && (@email_notification.new_items_category == "" || @email_notification.new_items_category==auction.category)
          @all_recipients = @all_recipients + user.username
        end
      end
    end

    # send the email only when there is at least 1 recipient
    mail(:bcc => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] New auction for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def send_announcement_from_other_users_auction_message(auction)
    @title = auction.title
    @bids_email =  Bid.where("silent_auction_id = ?",auction.id)
    @all_recipients = "twgs.twgs@gmail.com"
    if @bids_email != nil
      @bids_email.each do |bid|
        if @all_recipients != "" then
          @all_recipients = @all_recipients + ", "
        end
        @email_notification=EmailNotification.find_by_users_id(bid.user_id)
        if @email_notification != nil
          if @email_notification.auction_messages_by_other
             @user=User.find_by_id(bid.user_id)
             @all_recipients = @all_recipients + @user.username
          end
        end
       end
    end
    # send the email only when there is at least 1 recipient
    mail(:bcc => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] New auction messages for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def send_announcement_from_creator_auction_message(auction)
    @title = auction.title
    @bids_email =  Bid.where("silent_auction_id = ?",auction.id)
    @all_recipients = "twgs.twgs@gmail.com"
    if @bids_email != nil
        @bids_email.each do |bid|
        if @all_recipients != "" then
          @all_recipients = @all_recipients + ", "
        end
        @email_notification=EmailNotification.find_by_users_id(bid.user_id)
        if @email_notification != nil
          if @email_notification.auction_messages_by_creator
            @user=User.find_by_id(bid.user_id)
            @all_recipients = @all_recipients + @user.username
          end
        end
      end
    end
    # send the email only when there is at least 1 recipient
    mail(:bcc => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] New auction messages for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
  def send_announcement_to_creator_auction_message(userId,username,title)
    @title = title
    @userId = userId
    @username = username
    @all_recipients =""
    @email_notification=EmailNotification.find_by_users_id(@userId)
    if @email_notification != nil
        if @email_notification.creator_auction_messages
          @all_recipients = @username
        end
    end
    # send the email only when there is at least 1 recipient
    mail(:bcc => "#{@all_recipients}", :subject => "[TW Garage Sale] [SPAM] New auction messages for \"#{@title}\"", :from => 'GarageSale@no-reply.thoughtworks.com')
  end
end
