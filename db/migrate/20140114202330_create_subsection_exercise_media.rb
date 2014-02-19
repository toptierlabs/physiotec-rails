class CreateSubsectionExerciseMedia < ActiveRecord::Migration
  def change
    create_table :subsection_exercises do |t|
      t.references :subsection
      t.references :exercise_medium

      t.timestamps
    end
    add_index :subsection_exercises, :subsection_id
    add_index :subsection_exercises, :exercise_medium_id
    add_index :subsection_exercises, [:exercise_medium_id, :subsection_id], unique: true,
              name: "index_subsection_exercises_on_exercise_medium_and_subsection"
  end
end
