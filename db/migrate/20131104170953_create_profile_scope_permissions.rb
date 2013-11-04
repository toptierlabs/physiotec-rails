class CreateProfileScopePermissions < ActiveRecord::Migration
  def change
    create_table :profile_scope_permissions do |t|
      t.references :profile
      t.references :scope_permission

      t.timestamps
    end
    add_index :profile_scope_permissions, :profile_id
    add_index :profile_scope_permissions, :scope_permission_id
  end
end
