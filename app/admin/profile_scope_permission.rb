ActiveAdmin.register ProfileScopePermission do
  menu :parent => "3. Profiles", :label => "Scope Permissions"

    index do
    column :id
    column :profile
    column :scope_permission
    column :created_at
    column :updated_at
    default_actions
  end

end