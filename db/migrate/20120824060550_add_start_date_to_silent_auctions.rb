class AddStartDateToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :start_date, :date

  end
end
