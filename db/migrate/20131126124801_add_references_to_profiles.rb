class AddReferencesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :api_license_id, :integer
    add_index :profiles, :api_license_id

    add_column :permissions, :api_license_id, :integer
    add_index :permissions, :api_license_id
  end
end
