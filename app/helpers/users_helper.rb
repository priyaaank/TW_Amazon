module UsersHelper
  def ensure_user_has_a_region
    puts "*****u_helper*****"
    unless current_user.region.nil?
      unless current_user.region == ""
        puts " region selected "
      else
        puts " region is empty "
        redirect_to new_region_user_path(current_user)
      end
    else
      puts "  region is nil  "
      redirect_to new_region_user_path(current_user)
      #index_path
    end
  end  
end
