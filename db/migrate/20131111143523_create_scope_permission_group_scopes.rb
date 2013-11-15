class CreateScopePermissionGroupScopes < ActiveRecord::Migration
  def change
    create_table :scope_permission_group_scopes do |t|
      t.references :scope_permission
      t.references :scope

      t.timestamps
    end
    add_index :scope_permission_group_scopes, :scope_permission_id
    add_index :scope_permission_group_scopes, :scope_id
  end
end
