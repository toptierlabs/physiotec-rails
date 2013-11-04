class AddScopeGroupIdToScopes < ActiveRecord::Migration
  def change
    add_column :scopes, :scope_group_id, :integer
  end
end
