class RemovePublicApiKeyAndSecretApiKeyFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :public_api_key
    remove_column :users, :secret_api_key
  end

  def down
    add_column :users, :secret_api_key, :string
    add_column :users, :public_api_key, :string
  end
end
