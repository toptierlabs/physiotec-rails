class CreateSubsectionExercises < ActiveRecord::Migration
  def change
    create_table :subsection_exercises do |t|
      t.references :subsection
      t.references :exercise

      t.timestamps
    end
    add_index :subsection_exercises, :subsection_id
    add_index :subsection_exercises, :exercise_id
    add_index :subsection_exercises, [:exercise_id, :subsection_id], unique: true
  end
end
