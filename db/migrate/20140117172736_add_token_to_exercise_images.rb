class AddTokenToExerciseImages < ActiveRecord::Migration
  def change
    add_column :exercise_images, :token, :string
    add_column :exercise_illustrations, :token, :string
  end
end
