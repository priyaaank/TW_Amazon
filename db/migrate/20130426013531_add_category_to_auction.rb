class AddCategoryToAuction < ActiveRecord::Migration
  def change
    remove_column :silent_auctions, :category
    add_column :silent_auctions, :category_id, :integer
  end
end
