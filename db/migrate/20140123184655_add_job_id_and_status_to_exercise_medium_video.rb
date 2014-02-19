class AddJobIdAndStatusToExerciseMediumVideo < ActiveRecord::Migration
  def change
    add_column :exercise_medium_videos, :job_id, :string
    add_column :exercise_medium_videos, :status, :string
  end
end
