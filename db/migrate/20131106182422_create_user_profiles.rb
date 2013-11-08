class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.references :profile

      t.timestamps
    end
    add_index :user_profiles, :user_id
    add_index :user_profiles, :profile_id
  end
end
