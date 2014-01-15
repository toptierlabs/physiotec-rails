class CreateSectionData < ActiveRecord::Migration
  def up
    create_table :section_data do |t|
    	t.references :api_license, :null => false
      t.references :context, :null => false,
                             :polymorphic => true

      t.timestamps
    end
    add_index :section_data, :api_license_id
    add_index :section_data, [:context_type, :context_id]
    SectionDatum.create_translation_table! :name => :string
  end

  def down
  	drop_table :section_data
  	SectionDatum.drop_translation_table!
  end
end
