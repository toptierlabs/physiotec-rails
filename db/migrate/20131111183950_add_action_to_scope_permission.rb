class AddActionToScopePermission < ActiveRecord::Migration
  def change
    add_column :scope_permissions, :action_id, :integer
  end
end
