class CreateSilentAuctions < ActiveRecord::Migration
  def change
    create_table :silent_auctions do |t|
      t.string :title
      t.text :description
      t.boolean :open, :default => true

      t.timestamps
    end
  end
end
