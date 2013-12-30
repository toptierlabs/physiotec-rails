class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.references :api_license
      t.string :locale
      t.string :description

      t.timestamps
    end
    add_index :languages, :api_license_id
  end
end
