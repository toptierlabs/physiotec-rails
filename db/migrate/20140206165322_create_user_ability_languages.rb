class CreateUserAbilityLanguages < ActiveRecord::Migration
  def change
    create_table :user_ability_languages do |t|
      t.references :user_ability
      t.references :language
      t.references :ability
      t.references :user

      t.timestamps
    end
    add_index :user_ability_languages, :user_ability_id
    add_index :user_ability_languages, :language_id
    add_index :user_ability_languages, :ability_id
    add_index :user_ability_languages, :user_id
  end
end
