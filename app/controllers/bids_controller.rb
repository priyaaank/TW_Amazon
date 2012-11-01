class BidsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  def create
    #@bid = Bid.new(params[:bid])
    @bid = current_user.bids.build(params[:bid])
    #@bid = Bid.new
    respond_to do |format|
      if @bid.save
        #msg = "Bid of $#{@bid.amount} has been placed successfully"
        #format.html { redirect_back_with_success(silent_auctions_path, msg) }
        item_type = SilentAuction.find(@bid.silent_auction_id).item_type
        if item_type == 'Silent Auction'
          format.html { redirect_back_with_success(silent_auctions_path,"") }
          format.js { render 'create'}
        else
          format.html { redirect_back_with_success(normal_auctions_silent_auctions_path,"") }
          format.js { render 'update'}  
        end
      else
        err_msg = @bid.errors.full_messages[0]
        # format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
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
        #msg = "Bid of $#{@bid.amount} has been placed successfully"
        #format.html { redirect_back_with_success(silent_auctions_path, msg) }
        format.html { redirect_back_with_success(normal_auctions_silent_auctions_path,"") }
        format.js { render 'update'}  
      else
        err_msg = @bid.errors.full_messages[0]
        format.html { redirect_back_with_error(normal_auctions_silent_auctions_path) }
        format.js { render 'fail', :locals => { :errMsg => "#{err_msg}" } }
      end
    end
  end

  def update_OLD
    #@bid = Bid.new
    #@bid = current_user.bids.build(params[:bid])
    
    lastBid = Bid.where("silent_auction_id = ? AND user_id = ?", params[:bid]['silent_auction_id'], current_user.id).first
    @bid = lastBid
    update = false
    update = true unless lastBid.nil?
    
    if update
      lastAmount = lastBid.amount
      highestBid = SilentAuction.find(params[:bid]['silent_auction_id']).bids.active.highFirst.earlier.first.amount
      
      puts "*" * 20
      puts update
      puts lastAmount
      puts highestBid
           
      lastBid.amount = params[:bid]['amount']
      
      # check whether or not the new amount of bid is higher then the current highest bid
      update = false unless lastBid.save

      puts update
      
    end
    
    #redirect_to "/silent_auctions/normal_auctions"
    
    #redirect_to silent_auctions_path
    #redirect_to(:back)
    respond_to do |format|
      #if @bid.save
        msg = "Hahaha"
        format.html { redirect_back_with_success(normal_auctions_silent_auctions_path, msg) }
        format.js { render 'update'}
      #else
        # err_msg = @bid.errors.full_messages[0]
        # format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
      #end
    end
  end

  def withdraw
    @bid = Bid.find(params[:id])
    if @bid.user_id != current_user.id
      session[:return_to] ||= request.referer
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Withdrawal!</h4>You cannot withdraw bids of other users"
      redirect_back_or index_path
    else
      auction = SilentAuction.find(@bid.silent_auction_id)
      respond_to do |format|
        if @bid.withdraw
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
    #format.html{ redirect_back_with_success(normal_auctions_silent_auctions_path, "test") }
    #@bid.update_attributes(params[:bid])
    #redirect_to(:back)    
  end

  def delete
    @bid = Bid.find(params[:id])
    #lastBid = Bid.where("silent_auction_id = ? AND user_id = ?", params[:bid]['silent_auction_id'], current_user.id).first
    #@bid = lastBid
    silent_auction_id = @bid.silent_auction_id
    puts "*" * 20
    @auction = SilentAuction.find(silent_auction_id)
    puts @auction.bids.active.count    
    @bid.destroy
    #@auction = SilentAuction.find(silent_auction_id)
    puts @auction.title
    puts @auction.bids.active.count    
    #redirect_back_with_success(normal_auctions_silent_auctions_path,"Your bid has been successfully removed")
    respond_to do |format|
      msg = "Bid withdrawn successfully"
      format.html { redirect_back_with_success(normal_auctions_silent_auctions_path, msg) }
      format.js { render 'delete_done' }
    end       
  end
end
