class AddTokenToExerciseMedia < ActiveRecord::Migration
  def change
    add_column :exercise_media, :token, :string
  end
end
