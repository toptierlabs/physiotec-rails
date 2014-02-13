class CreateProfileAbilities < ActiveRecord::Migration
  def change
    create_table :profile_abilities do |t|
      t.references :profile
      t.references :ability

      t.timestamps
    end
    add_index :profile_abilities, [:profile_id, :ability_id], unique: true,
              name: "index_profile_abilities_on_profile_and_ability_and_scope"
    add_index :profile_abilities, :profile_id
    add_index :profile_abilities, :ability_id
  end
end