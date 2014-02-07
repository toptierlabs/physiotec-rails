class CreateUserAbilities < ActiveRecord::Migration
  def change
    create_table :user_abilities do |t|
      t.references :user
      t.references :ability
      t.integer :scope_id

      t.timestamps
    end
    add_index :user_abilities, [:user_id, :ability_id, :scope_id], unique: true
    add_index :user_abilities, :user_id
    add_index :user_abilities, :ability_id
    add_index :user_abilities, :scope_id
  end
end
