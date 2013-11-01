class CreateProfileAndScopes < ActiveRecord::Migration
  def change
    create_table :profiles_scopes do |t|
      t.references :profile
      t.references :scope

      t.timestamps
    end
    add_index :profiles_scopes, :profile_id
    add_index :profiles_scopes, :scope_id
  end
end
