ActiveAdmin.register Scope do
  menu :parent => "1. Scopes", :label => "Scopes"

  index do
    column :id
    column :scope_group
    column :name
    column :created_at
    column :updated_at
    default_actions
  end
end
