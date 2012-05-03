class BidsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!

  def create
    @bid = Bid.new
    respond_to do |format|
      # check if user has place any bid for this auction or not
      exist_bids = Bid.where("silent_auction_id = ? AND user_id = ?", params[:bid][:silent_auction_id] , current_user.id).first
      if exist_bids != nil
        flash[:error] = 'You have already bid on this auction'
        format.html { redirect_back_or silent_auction_path }
        format.js { render 'fail.js.erb', :locals => { :errMsg => "You have already bid on this auction"} }
      else
        @bid = current_user.bids.build(params[:bid])
        if @bid.save
          flash[:error] = "Bid of $#{@bid.amount} has been placed successfully"
          format.html { redirect_back_or silent_auction_path }
          format.js { render 'create.js.erb'}
        else
          err_msg = @bid.full_messages
          flash[:error] = "Error! Bid #{err_msg}"
          format.html { redirect_back_or silent_auction_path }
          format.js { render 'fail.js.erb', :locals => { :errMsg => "Bid #{err_msg}" } }
        end
      end
    end
  end

  def withdraw
    @bid = Bid.find(params[:id])
    auction = SilentAuction.find(@bid.silent_auction_id)
    respond_to do |format|
      if @bid.withdraw
          flash[:success] = "Bid withdrawn successfully"
          format.html { redirect_back_or silent_auction_path }
          format.js { render 'withdraw_done.js.erb' }
      else
        err_msg = @bid.full_messages
        flash[:error] = err_msg
        format.html { redirect_back_or silent_auction_path }
        format.js { render 'fail_withdraw.js.erb', :locals => { :errMsg => err_msg } }
      end
    end
  end

end
