class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.string :name
      t.references :license

      t.timestamps
    end
    add_index :clinics, :license_id
  end
end
