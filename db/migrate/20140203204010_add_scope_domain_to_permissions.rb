class AddScopeDomainToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :minimum_scope_id, :integer
    add_column :permissions, :maximum_scope_id, :integer
    
    add_index  :permissions, :minimum_scope_id
    add_index  :permissions, :maximum_scope_id
  end
end
