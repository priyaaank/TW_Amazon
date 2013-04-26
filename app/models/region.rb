class Region < ActiveRecord::Base
 attr_accessible :code, :currency, :timezone, :maximum

 def to_s
   code
 end
end
