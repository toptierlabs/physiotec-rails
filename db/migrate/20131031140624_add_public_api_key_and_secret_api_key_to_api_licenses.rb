class AddPublicApiKeyAndSecretApiKeyToApiLicenses < ActiveRecord::Migration
  def change
    add_column :api_licenses, :public_api_key, :string
    add_index :api_licenses, :public_api_key
    add_column :api_licenses, :secret_api_key, :string
  end
end
