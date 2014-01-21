class CreateExerciseVideos < ActiveRecord::Migration
  def change
    create_table :exercise_videos do |t|
      t.references :exercise
      t.string :video
      t.string :token

      t.timestamps
    end
    add_index :exercise_videos, :exercise_id
    add_index :exercise_videos, :token, unique: true
  end
end
