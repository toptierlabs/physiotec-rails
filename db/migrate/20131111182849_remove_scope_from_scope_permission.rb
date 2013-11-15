class RemoveScopeFromScopePermission < ActiveRecord::Migration
  def up
    remove_column :scope_permissions, :scope_id
  end

  def down
    add_column :scope_permissions, :scope, :integer
  end
end
