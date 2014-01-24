class AddJobIdAndStatusToExerciseVideo < ActiveRecord::Migration
  def change
    add_column :exercise_videos, :job_id, :string
    add_column :exercise_videos, :status, :string
  end
end
