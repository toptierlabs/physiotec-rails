class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
      t.references :permission
      t.integer :action_id
      t.integer :scope_id

      t.timestamps
    end

    add_index :abilities, :permission_id
    add_index :abilities, :action_id
    add_index :abilities, :scope_id
    add_index :abilities, [:permission_id, :action_id, :scope_id], unique: true
  end
end
