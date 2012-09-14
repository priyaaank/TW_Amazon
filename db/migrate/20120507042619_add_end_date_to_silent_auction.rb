class AddEndDateToSilentAuction < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :end_date, :date

  end
end
