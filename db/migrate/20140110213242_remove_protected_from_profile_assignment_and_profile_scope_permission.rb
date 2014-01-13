class RemoveProtectedFromProfileAssignmentAndProfileScopePermission < ActiveRecord::Migration
  def up
    remove_column :profile_assignments, :protected
    remove_column :profile_scope_permissions, :protected
  end

  def down
    add_column :profile_assignments, :protected, :boolean, :default => false
    add_column :profile_scope_permissions, :protected, :boolean, :default => false
  end
end
