class RemovePermissionIdFromScopes < ActiveRecord::Migration
  def up
    remove_column :scopes, :permission_id
  end

  def down
    add_column :scopes, :permission_id, :integer
  end
end
