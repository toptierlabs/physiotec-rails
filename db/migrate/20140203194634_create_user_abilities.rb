class CreateUserAbilities < ActiveRecord::Migration
  def change
    create_table :user_abilities do |t|
      t.references :user
      t.references :ability

      t.timestamps
    end
    add_index :user_abilities, [:user_id, :ability_id], unique: true
    add_index :user_abilities, :user_id
    add_index :user_abilities, :ability_id
  end
end
