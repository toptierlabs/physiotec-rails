class CreateScopeGroups < ActiveRecord::Migration
  def change
    create_table :scope_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
