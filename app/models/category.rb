class Category < ActiveRecord::Base
  attr_accessible :category
  before_destroy :check_for_auction
  private
  def check_for_auction
    unless SilentAuction.find_all_by_category_id(self.id).count == 0
      self.errors[:category] = "Cannot Delete a category while an auction exists for the category"
      return false
    end
  end
end
