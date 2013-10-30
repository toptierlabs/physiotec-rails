class RolifyCreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:api_license_admins_roles, :id => false) do |t|
      t.references :api_license_admin
      t.references :role
    end

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:api_license_admins_roles, [ :api_license_admin_id, :role_id ],
              :name => 'index_ApiLicenseAdminsRolesOnApiLicenseAdminIdAndRoleId')
  end
end