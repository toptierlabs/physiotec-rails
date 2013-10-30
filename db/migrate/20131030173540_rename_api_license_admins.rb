class RenameApiLicenseAdmins< ActiveRecord::Migration
  def change
    rename_table :api_license_admins, :users
    rename_table :api_license_admins_roles, :users_roles
    rename_column :users_roles, :api_license_admin_id, :user_id
    rename_index :users_roles, 'index_ApiLicenseAdminsRolesOnApiLicenseAdminIdAndRoleId', 'index_users_roles_on_user_id_and_role_id'
  end 
end 