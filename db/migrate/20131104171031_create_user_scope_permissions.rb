class CreateUserScopePermissions < ActiveRecord::Migration
  def change
    create_table :user_scope_permissions do |t|
      t.references :user
      t.references :scope_permission

      t.timestamps
    end
    add_index :user_scope_permissions, :user_id
    add_index :user_scope_permissions, :scope_permission_id
  end
end
