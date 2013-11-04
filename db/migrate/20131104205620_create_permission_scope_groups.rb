class CreatePermissionScopeGroups < ActiveRecord::Migration
  def change
    create_table :permission_scope_groups do |t|
      t.references :permission
      t.references :scope_group

      t.timestamps
    end
    add_index :permission_scope_groups, :permission_id
    add_index :permission_scope_groups, :scope_group_id
  end
end
