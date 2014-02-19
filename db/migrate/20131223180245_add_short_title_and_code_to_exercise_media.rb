class AddShortTitleAndCodeToExerciseMedia < ActiveRecord::Migration
  def change
    add_column :exercise_media, :short_title, :string
    add_column :exercise_media, :code, :string
  end
end
