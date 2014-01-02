class RemoveApiLicenseIdFromScopeGroups < ActiveRecord::Migration
  def up
    remove_column :scope_groups, :api_license_id
  end

  def down
    add_column :scope_groups, :api_license_id, :integer
  end
end
