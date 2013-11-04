class CreateScopePermissions < ActiveRecord::Migration
  def change
    create_table :scope_permissions do |t|
      t.references :scope
      t.references :permission

      t.timestamps
    end
    add_index :scope_permissions, :scope_id
    add_index :scope_permissions, :permission_id
  end
end
