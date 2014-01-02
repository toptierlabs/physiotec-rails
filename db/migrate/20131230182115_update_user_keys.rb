class UpdateUserKeys < ActiveRecord::Migration
  def up
  	remove_index :users, name: :index_api_license_admins_on_email
  	add_index(:users, [:email, :api_license_id], unique: true)
  end

  def down
  	remove_index :users, [:email, :api_license_id]
  	add_index :users, :email, name: 'index_api_license_admins_on_email', :unique => true
  end
end
