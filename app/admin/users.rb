ActiveAdmin.register User do
   controller { with_role :admin }
    form do |f|
      f.inputs "User Details" do
        f.input :region_id, :as => :select, :collection => Region.all
        f.input :username
        f.input :encrypted_password
        f.input :admin
      end
      f.buttons
    end
end
