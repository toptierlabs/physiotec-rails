class CreateSubsectionData < ActiveRecord::Migration
  def up
    create_table :subsection_data do |t|
      t.references :section_datum,         :null => false

      t.timestamps
    end
    add_index :subsection_data, :section_datum_id
    SubsectionDatum.create_translation_table! :name => :string
  end

  def down
  	drop_table :subsection_data
  	SubsectionDatum.drop_translation_table!
  end
end
