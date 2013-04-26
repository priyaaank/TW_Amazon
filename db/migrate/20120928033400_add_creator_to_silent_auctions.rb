class AddCreatorToSilentAuctions < ActiveRecord::Migration
  def change
    add_column :silent_auctions, :creator, :string

  end
end
