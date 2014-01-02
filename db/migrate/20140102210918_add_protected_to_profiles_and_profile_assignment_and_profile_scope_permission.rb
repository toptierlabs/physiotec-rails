class AddProtectedToProfilesAndProfileAssignmentAndProfileScopePermission < ActiveRecord::Migration
  def change
    add_column :profiles, :protected, :boolean, :default => false
    add_column :profile_assignments, :protected, :boolean, :default => false
    add_column :profile_scope_permissions, :protected, :boolean, :default => false
  end
end
