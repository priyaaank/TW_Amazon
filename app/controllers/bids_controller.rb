class BidsController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!

  def create
    @bid = Bid.new
    #@bid.accessible = [:silent_auction_id]
    @bid = current_user.bids.build(params[:bid])
    if @bid.save
      flash[:success] = "Bid of $#{@bid.amount} has been placed successfully"
    else
      flash[:error] = "Error! Bid not placed"
    end
    redirect_to index_path
  end

  def cancel(bid)
    bid.active = false
    if bid.save
      flash[:success] = "Bid cancelled successfully"
    else
      flash[:error] = "Error! Bid not cancelled"
    end
  end

end
