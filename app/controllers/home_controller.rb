class HomeController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :only => :landing
  before_filter :ensure_signed_in_user_has_a_region, :only => :landing
  def login
    if user_signed_in?
      redirect_to landing_path
    else
      if test_mode?
        # provide homepage with two login options (CAS or test accounts)
        @title = "Login"
        respond_to do |format|
          format.html # login.html.haml
        end
      else
        redirect_to user_omniauth_authorize_path(:cas)
        # redirect_to index_path
      end
    end
  end
  def landing

    @title = "Running Silent Auctions"
    @search_category=""
    @running_auctions = SilentAuction.running(current_user.timezone).recent.includes(:bids).where("region_id = '#{current_user.region_id}'")
    temp = SilentAuction.running(current_user.timezone).recent.includes(:bids).where("region_id = '#{current_user.region_id}'")
    temp.each do |auction|
      if auction.end_date < Date.today
        temp.delete(auction)
      end
    end
    @ending_soon = temp.sort! {|a,b| a.end_date <=> b.end_date}
  end

end
