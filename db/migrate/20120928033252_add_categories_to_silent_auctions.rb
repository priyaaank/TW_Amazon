class AddCategoriesToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :category, :string, :default => "Computers"

  end
end
