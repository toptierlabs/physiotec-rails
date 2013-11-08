class AddApiLicenseToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :api_license_id, :integer
  end
end
