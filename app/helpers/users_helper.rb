module UsersHelper
  def ensure_signed_in_user_has_a_region
    unless current_user.region.nil?
      unless current_user.region == ""
        # there is no alternative redirection required in this case, the system will go straight to the requested link
        #puts " region has been selected for this particular user "
      else
        redirect_to new_region_user_path(current_user)
      end
    else
      redirect_to new_region_user_path(current_user)
    end
  end  
  
  def ensure_user_has_a_region
    unless current_user.region.nil?
      unless current_user.region == ""
        index_path
      else
        new_region_user_path(current_user)
      end
    else
      new_region_user_path(current_user)
    end
  end  
end
