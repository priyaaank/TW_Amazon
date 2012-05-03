class BidsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!

  def create
    @bid = Bid.new
    respond_to do |format|
      # check if user has place any bid for this auction or not
      exist_bids = Bid.where("silent_auction_id = ? AND user_id = ?", params[:bid][:silent_auction_id] , current_user.id).first
      if exist_bids != nil
        format.html { redirect_to request.referer, :alert => 'You have already bid on this auction' }
        format.js { render 'fail.js.erb', :locals => { :errMsg => "You have already bid on this auction"} }
      else
        @bid = current_user.bids.build(params[:bid])
        if @bid.save
          format.html { redirect_to request.referer, :notice => "Bid of $#{@bid.amount} has been placed successfully" }
          format.js { render 'create.js.erb'}
        else
          errMsg = @bid.errors[:amount][0]
          format.html { redirect_to request.referer, :alert => "Error! Bid #{errMsg}" }
          format.js { render 'fail.js.erb', :locals => { :errMsg => "Bid #{errMsg}" } }
        end
      end
    end
  end

  def withdraw
    @bid = Bid.find(params[:id])
    auction = SilentAuction.find(@bid.silent_auction_id)
    respond_to do |format|
      if auction.open
        @bid.active = false
        if @bid.save
          format.html { redirect_to request.referer, :notice => "Bid withdrawn successfully" }
          format.js { render 'withdraw_done.js.erb' }
        else
          format.html { redirect_to request.referer, :alert => 'Error! Bid not withdrawn' }
          format.js { render 'fail_withdraw.js.erb', :locals => {:errMsg => 'Something went wrong!<br/> Bid cannot be withdrawn'}}
        end
      else
        format.html { redirect_to request.referer, :error => 'Error! Auction was closed! Bid cannot be withdrawn' }
        format.js { render 'fail_withdraw.js.erb', :locals => {:errMsg => 'Auction has been closed! Cannot withdraw bid anymore'}}
      end
    end
  end

end
