class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.integer :maximum_clinics
      t.integer :maximum_users
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
