class CreateRegions < ActiveRecord::Migration
  def up
    create_table :regions do |t|
      t.string :code
      t.string :currency
      t.string :timezone
      t.integer :maximum
      t.timestamps
    end


    Region.create(:code => 'AUS', :currency => 'AU$', :timezone => 'Melbourne', :maximum => 10000)
    Region.create(:code => 'IND', :currency => 'Rs', :timezone => 'New Delhi', :maximum => 100000)
    Region.create(:code => 'BRA', :currency => 'R$', :timezone => 'Brasilia', :maximum => 5000)
  end

  def down
    drop_table :regions
  end
end
