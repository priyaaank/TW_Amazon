class UsersController < ApplicationController
  include ApplicationHelper
  include SilentAuctionsHelper

  before_filter :authenticate_user!
  before_filter :correct_user
  
  before_filter :validate_timezone

  def faq_page
    @title = "Frequently Asked Questions (and the answers)"
   
  end
  
  def region_management
    @title = "Region Management"
    
  end
  
  def validate_timezone
   @region_na=params[:region_currency]
  end
  
  def update_region_YAML
     
    
    regex = Regexp.new("^[1-9]{1}[0-9]*$");
    @regionname=params[:region_name]
    @regioncurrency=params[:region_currency]
    @regiontimezone=params[:region_timezone]
    @regionmaximum=params[:region_maximum]
    begin
    Time.zone.now.in_time_zone(params[:region_timezone])
    if(params[:region_name]=='')
      flash[:error] = "Name can not be empty".html_safe
    else if(params[:region_currency]=="")
        flash[:error] = "Currency can not be empty".html_safe
    else if(params[:region_maximum]=="" or params[:region_maximum].match(regex).nil?)
       flash[:error] = "Maximum can not be empty or Maximum must be a number".html_safe
       else
        config_file = "#{Rails.root}/config/region.yml"
        yaml = YAML.load_file(config_file)
        fake_yaml = yaml
        max="'"+params[:region_maximum]+"'"
    # #fake_yaml['USA'] = "new content\n\r\tlabel: value"
        new_content = {'currency'=>params[:region_currency], 'timezone'=>params[:region_timezone], 'maximum'=>params[:region_maximum]}
        fake_yaml[params[:region_name]] = new_content
        flash[:success] = "The Region has been save".html_safe
        File.open( "#{Rails.root}/config/region.yml", 'w' ) do |out|
          YAML.dump(fake_yaml, out)
        end
        redirect_to index_path
        end
      end
    end
    rescue
       flash[:error] = "Timezone can not be empty or must be a valid Timezone".html_safe
     
    end
    # 
    
    #puts "*" * 20
    #puts fake_yaml
    # 
    # flash[:error] = "Error".html_safe
    # redirect_to (:back)
    # # end
    
  end
  
  def show
    @title = "My Bids"
    @user = User.find(params[:id])
    @running_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => true}).where("region = ?", @user.region).recent
    @closed_bids = @user.bids.joins(:silent_auction).where(:silent_auctions => {:open => false}).where("bids.active = ? AND region = ?", true, @user.region).recent
  end

  def list_my_items
    @title = "My Silent Auctions"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @timezone = get_region_config(@user.region)["timezone"]
    @running_bids = SilentAuction.running(@timezone).where("creator = ? AND item_type = 'Silent Auction' AND region = ?", @user.username, @user.region).where({:open => true}).recent
    @closed_bids = SilentAuction.closed.where("creator = ? AND region = ?", @user.username, @user.region).recent
    @expired_bids = SilentAuction.expired.where("creator = ? AND region = ?", @user.username, @user.region).recent
    @future_bids = SilentAuction.future(@timezone).where({:open => true}).where("item_type = 'Silent Auction' AND region = ?", @user.region).recent#need timezone to filter the future auction items
  end
  
  def list_my_sales
    @title = "My Sales"
    @user = User.find(params[:id])
    puts "*" * 40
    puts @user.username
    @timezone = get_region_config(@user.region)["timezone"]
    @running_bids = SilentAuction.running(@timezone).where("creator = ? AND item_type = 'Quick Sale' AND region = ?", @user.username, @user.region).where({:open => true}).recent
    @future_bids = SilentAuction.future_sale(@timezone).where({:open => true}).where("creator = ? AND region = ?", @user.username, @user.region).recent#need timezone to filter the future auction items
  end
  
  def notification
    if @user.email == nil
      @user.email = 'on'
      @user.save
    end
    @user = current_user
  end

  def correct_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:error] = "<h4 class='alert-heading'>Unauthorized Access!</h4>Sorry, You don't have permission to view bids of other users".html_safe
      redirect_back_or(index_path)
    end
  end
  
  def new_region
    @user = User.find(params[:id])
  end
  
  def update_region
    @user.region = params[:user][:region]
    @user.save!
    redirect_to index_path
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to(:back)
  end
end
