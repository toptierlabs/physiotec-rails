ActiveAdmin.register ScopePermission do
menu :parent => "2. Permissions", :label => "Scope Permissions"
  index do
    column :id
    column :permission
    column :scope
    column :created_at
    column :updated_at
    default_actions
  end
end
