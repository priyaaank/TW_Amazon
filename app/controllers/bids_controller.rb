class BidsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!

  def create
    @bid = Bid.new
    @bid = current_user.bids.build(params[:bid])
    respond_to do |format|
      if @bid.save
        msg = "Bid of $#{@bid.amount} has been placed successfully"
        format.html { redirect_back_with_success(silent_auctions_path, msg) }
        format.js { render 'create.js.erb'}
      else
        err_msg = @bid.errors.full_messages[0]
        format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
        format.js { render 'fail.js.erb', :locals => { :errMsg => "#{err_msg}" } }
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
      auction = SilentAuction.find(@bid.silent_auction_id)
      respond_to do |format|
        if @bid.withdraw
            msg = "Bid withdrawn successfully"
            format.html { redirect_back_with_success(silent_auctions_path, msg) }
            format.js { render 'withdraw_done.js.erb' }
        else
          err_msg = @bid.errors.full_messages[0]
          format.html { redirect_back_with_error(silent_auctions_path,"Error! #{err_msg}") }
          format.js { render 'fail_withdraw.js.erb', :locals => { :errMsg => err_msg } }
        end
      end
    end
  end

end
