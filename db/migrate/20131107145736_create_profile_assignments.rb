class CreateProfileAssignments < ActiveRecord::Migration
  def change
    create_table :profile_assignments do |t|
      t.references :profile
      t.references :destination_profile

      t.timestamps
    end
    add_index :profile_assignments, :profile_id
    add_index :profile_assignments, :destination_profile_id
  end
end
