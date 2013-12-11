class AddApiLicenseToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :api_license_id, :integer
    add_index :clinics, :api_license_id
  end
end
