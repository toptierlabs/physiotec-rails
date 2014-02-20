ActiveAdmin.register Permission do
  filter :scope_groups
  filter :name
  filter :model_name
  filter :created_at
  filter :updated_at

  #customization on new and edit profile pages
  form do |f|
    f.inputs "Permission Attributes" do
      f.input :name
      f.input :model_name
      f.input :minimum_scope
      f.input :maximum_scope
    end

    f.actions
  end

end