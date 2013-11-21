class AddScopeKeyToScopePermissions < ActiveRecord::Migration
  def up
  	add_index :scope_permissions, :action_id
  end

  def down
  end
end
