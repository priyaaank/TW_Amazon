module UsersHelper
  def ensure_signed_in_user_has_a_region
      redirect_to new_region_user_path(current_user) if current_user.region.blank?
  end

  def ensure_user_has_a_region
    if current_user.region.blank?
      new_region_user_path(current_user)
    else
      index_path
    end
  end
end
