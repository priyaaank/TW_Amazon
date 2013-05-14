class AddDefaultCategoryToOldSilentAuctions < ActiveRecord::Migration

  class SilentAuction < ActiveRecord::Base
    attr_accessible :category_id
    belongs_to :category
  end
  def up
   default_category_id = Category.create(:category => "Miscellaneous").id
    say("Miscellaneous Category created with id : "+default_category_id.to_s)
    SilentAuction.where("category_id is null").each do |auction|
     auction.category_id = default_category_id
     auction.save!
    end
  end

  def down
    default_category_id = Category.find_by_category("Miscellaneous").id
    SilentAuction.where("category_id is #{default_category_id}").each do |auction|
     auction.category_id = ""
      auction.save!
    end
    Category.delete_all(:category => "Miscellaneous")
  end
end