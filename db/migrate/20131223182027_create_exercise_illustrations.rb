class CreateExerciseIllustrations < ActiveRecord::Migration
  def change
    create_table :exercise_illustrations do |t|
      t.integer :exercise_id
      t.string :illustration

      t.timestamps
    end
    add_index :exercise_illustrations, :exercise_id
  end
end
