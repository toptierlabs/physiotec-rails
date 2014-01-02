class RemoveApiLicenseFromPermissions < ActiveRecord::Migration
  def up
    remove_column :permissions, :api_license_id
  end

  def down
    add_column :permissions, :api_license_id, :integer
  end
end
