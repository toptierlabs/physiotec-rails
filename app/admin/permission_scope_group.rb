ActiveAdmin.register PermissionScopeGroup do
 menu :parent => "2. Permissions", :label => "Permissions Scope Groups"

  index do
    column :id
    column :permission
    column :scope_group
    column :created_at
    column :updated_at
    default_actions
  end

end
