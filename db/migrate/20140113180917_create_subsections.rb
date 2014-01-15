class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.references :section,          :null => false
      t.references :subsection_datum, :null => false

      t.timestamps
    end
    add_index :subsections, :section_id
    add_index :subsections, :subsection_datum_id
    add_index :subsections, [:section_id, :subsection_datum_id], unique: true
  end

end

