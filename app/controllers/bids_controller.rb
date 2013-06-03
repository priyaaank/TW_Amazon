class BidsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  def create
    @bid = current_user.bids.build(params[:bid])
    respond_to do |format|
      if @bid.save
        item_type = SilentAuction.find(@bid.silent_auction_id).item_type
        title = SilentAuction.find(@bid.silent_auction_id).title
        @bids_email =  Bid.where("silent_auction_id = ?",@bid.silent_auction_id)
        if @bids_email.size>1
          @result = @bids_email.last(2)
          @outBidder_id = User.find(@result[0].user_id).username
          UserMailer.item_outbid(title,@outBidder_id).deliver
        else
          @user_id = @bids_email.first.user_id
          @email_notification=EmailNotification.find_by_users_id(@user_id)
          if @email_notification != nil
            if @email_notification.item_will_sell
              @creator = User.find(@user_id).username
              UserMailer.item_will_sell(title,@creator).deliver
            end
          end
        end
        if item_type == 'Silent Auction'
          format.html { redirect_back_with_success(silent_auctions_path,"") }
          format.js { render 'create'}
        else
          format.html { redirect_back_with_success(normal_auctions_silent_auctions_path,"") }
          format.js { render 'update'}
        end
      else
        err_msg = @bid.errors.full_messages[0]
        if item_type == 'Silent Auction'
          format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
        else
          format.html { redirect_back_with_error(normal_auctions_silent_auctions_path,"Error! #{err_msg}") }
        end
        format.js { render 'fail', :locals => { :errMsg => "#{err_msg}" } }
      end
    end
  end

  def update
    lastBid = Bid.where("silent_auction_id = ? AND user_id = ?", params[:bid]['silent_auction_id'], current_user.id).first
    @bid = lastBid
    @bid.amount = params[:bid]['amount']
    respond_to do |format|
      if @bid.save

        @bids_email =  Bid.where("silent_auction_id = ?",params[:bid]['silent_auction_id'])
        if @bids_email.size>1
          @result = @bids_email.last(2)
          @user_id=@result[0].user_id
          if current_user.id!=@user_id
            @outBidder_id = User.find(@user_id).username
            UserMailer.item_outbid(@bid.title,@outBidder_id).deliver
          end
        end

        format.html { redirect_back_with_success(normal_auctions_silent_auctions_path,"") }
        format.js { render 'update'}
      else
        err_msg = @bid.errors.full_messages[0]
        format.html { redirect_back_with_error(normal_auctions_silent_auctions_path,"") }
        format.js { render 'fail', :locals => { :errMsg => "#{err_msg}" } }
      end
    end
  end

  def withdraw
    @bid = Bid.find(params[:id])
    if @bid.user_id != current_user.id
      session[:return_to] ||= request.referer
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Withdrawal!</h4>You cannot withdraw bids of other users"
      redirect_back_or index_path
    else
      @auction = SilentAuction.find(@bid.silent_auction_id)
      respond_to do |format|
        if @bid.withdraw
            @bids_email =  Bid.where("silent_auction_id = ?",@bid.silent_auction_id)
            if @bids_email.size>0
              @user_id = @bids_email.last.user_id
              if current_user.id!=@user_id
                @outBidder_id = User.find(@user_id).username
                UserMailer.item_withdraw(@auction.title,@outBidder_id).deliver
              end
            end
            msg = "Bid withdrawn successfully"
            format.html { redirect_back_with_success(silent_auctions_path, msg) }
            format.js { render 'withdraw_done' }
        else
          err_msg = @bid.errors.full_messages[0]
          format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
          format.js { render 'fail_withdraw', :locals => { :errMsg => err_msg } }
        end
      end
    end
  end

  def update_amount
    puts "*" * 20

    last_bid = Bid.where("user_id = ? AND silent_auction_id = ?", params)

    currentHighestBid = SilentAuction.find(@bid.silent_auction_id).bids.active.highFirst.earlier.first
    puts currentHighestBid

    respond_to do |format|
      flash[:error] = "Test"
      format.html { redirect_back_with_success(silent_auctions_path, "msg") }
    end
  end

  def delete
    @bid = Bid.find(params[:id])
    silent_auction_id = @bid.silent_auction_id
    puts "*" * 20
    @auction = SilentAuction.find(silent_auction_id)
    puts @auction.bids.active.count
    @bid.destroy
    puts @auction.title
    puts @auction.bids.active.count
    @bids_email =  Bid.where("silent_auction_id = ?",@bid.silent_auction_id)
    if @bids_email.size>0
      @user_id = @bids_email.last.user_id
      if current_user.id!=@user_id
        @outBidder_id = User.find(@user_id).username
        UserMailer.item_withdraw(@auction.title,@outBidder_id).deliver
      end
    end
    respond_to do |format|
      msg = "Bid withdrawn successfully"
      format.html { redirect_back_with_success(normal_auctions_silent_auctions_path, msg) }
      format.js { render 'delete_done' }
    end
  end
end
