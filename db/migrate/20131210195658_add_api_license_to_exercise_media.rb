class AddApiLicenseToExerciseMedia < ActiveRecord::Migration
  def change
    add_column :exercise_media, :api_license_id, :integer
    remove_column :exercise_media, :license_id
    add_index :exercise_media, :api_license_id
  end
end
