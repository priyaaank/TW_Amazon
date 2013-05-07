ActiveAdmin.register Category do
  index do
    column :id
    column :category
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Category Name" do
      f.input :category
    end
    f.buttons
  end
end
