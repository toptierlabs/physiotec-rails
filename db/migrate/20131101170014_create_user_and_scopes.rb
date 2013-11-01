class CreateUserAndScopes < ActiveRecord::Migration
  def change
    create_table :users_scopes do |t|
      t.references :user
      t.references :scope

      t.timestamps
    end
    add_index :users_scopes, :user_id
    add_index :users_scopes, :scope_id
  end
end
