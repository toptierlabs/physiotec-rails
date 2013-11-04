class DropUsersScopes < ActiveRecord::Migration
  def up
  	drop_table :users_scopes
  end

  def down
  end
end
