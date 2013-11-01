class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name
      t.references :permission

      t.timestamps
    end
    add_index :scopes, :permission_id
  end
end
