class CreateExerciseMediumImages < ActiveRecord::Migration
  def change
    create_table :exercise_medium_images do |t|
      t.integer :exercise_medium_id
      t.string :image

      t.timestamps
    end
    add_index :exercise_medium_images, :exercise_medium_id
  end
end
