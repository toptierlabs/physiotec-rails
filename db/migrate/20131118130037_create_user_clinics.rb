class CreateUserClinics < ActiveRecord::Migration
  def change
    create_table :user_clinics do |t|
      t.references :user
      t.references :clinic
      t.timestamps
    end
    add_index :user_clinics, :user_id
    add_index :user_clinics, :clinic_id
  end
end
