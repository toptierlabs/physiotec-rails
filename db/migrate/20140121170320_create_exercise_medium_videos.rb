class CreateExerciseMediumVideos < ActiveRecord::Migration
  def change
    create_table :exercise_medium_videos do |t|
      t.references :exercise_medium
      t.string :video
      t.string :token

      t.timestamps
    end
    add_index :exercise_medium_videos, :exercise_medium_id
    add_index :exercise_medium_videos, :token
    add_index :exercise_medium_videos, [:token, :video, :exercise_medium_id], unique: true,
    name: 'index_videos_on_token_and_video_and_exercise_medium'


  end
end
