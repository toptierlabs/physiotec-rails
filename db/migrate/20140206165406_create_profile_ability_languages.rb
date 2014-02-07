class CreateProfileAbilityLanguages < ActiveRecord::Migration
  def change
    create_table :profile_ability_languages do |t|
      t.references :profile_ability
      t.references :language
      t.references :ability
      t.references :profile

      t.timestamps
    end
    add_index :profile_ability_languages, :profile_ability_id
    add_index :profile_ability_languages, :language_id
    add_index :profile_ability_languages, :ability_id
    add_index :profile_ability_languages, :profile_id
  end
end
