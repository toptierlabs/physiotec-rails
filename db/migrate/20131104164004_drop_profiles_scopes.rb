class DropProfilesScopes < ActiveRecord::Migration
  def up
  	drop_table :profiles_scopes
  end

  def down
  end
end
