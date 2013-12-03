class CreatePermissibleScopes < ActiveRecord::Migration

  def change
    create_table :permissible_scopes do |t|
      t.references :permissible, polymorphic: true
      t.references :scope

      t.timestamps
    end
    
    add_index :permissible_scopes, :permissible_id
    add_index :permissible_scopes, :permissible_type
  end

end
