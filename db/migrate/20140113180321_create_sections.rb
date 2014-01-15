class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :category,      :null => false
      t.references :section_datum, :null => false

      t.timestamps
    end

    add_index :sections, :category_id
    add_index :sections, :section_datum_id
    add_index :sections, [:section_datum_id, :category_id], unique: true
  end
end
