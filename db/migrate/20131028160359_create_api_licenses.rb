class CreateApiLicenses < ActiveRecord::Migration
  def change
    create_table :api_licenses do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
