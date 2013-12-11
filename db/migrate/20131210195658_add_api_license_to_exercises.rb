class AddApiLicenseToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :api_license_id, :integer
    remove_column :exercises, :license_id
    add_index :exercises, :api_license_id
  end
end
