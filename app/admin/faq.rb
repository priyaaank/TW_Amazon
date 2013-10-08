ActiveAdmin.register Faq do
   controller { with_role :admin }


  form do |f|
    f.inputs "FAQ" do
    f.input :question
    f.input :answer, :as => :text
    end
    f.buttons
  end
end
