class AddRegionToUser < ActiveRecord::Migration
   class User < ActiveRecord::Base
     attr_accessible :region, :region_code
     belongs_to :region
   end

  def up
    rename_column :users, :region, :region_code
    add_column :users, :region_id, :integer, :references  => "regions", :null => true
    User.where("region_code is not null").each {|user|
      user.region = Region.find_by_code(user.region_code)
      user.save!
    }
    remove_column :users, :region_code
  end

  def down
    add_column :users, :region_code, :string
    User.where("region_id is not null").each {|user|
      user.region_code = user.region.code
      user.save!
    }
    remove_column :users, :region_id
    rename_column :users, :region_code, :region
  end
end
