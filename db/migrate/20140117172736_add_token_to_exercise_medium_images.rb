class AddTokenToExerciseMediumImages < ActiveRecord::Migration
  def change
    add_column :exercise_medium_images, :token, :string
    add_column :exercise_medium_illustrations, :token, :string
  end
end
