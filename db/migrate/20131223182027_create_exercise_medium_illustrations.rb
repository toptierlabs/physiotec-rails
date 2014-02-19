class CreateExerciseMediumIllustrations < ActiveRecord::Migration
  def change
    create_table :exercise_medium_illustrations do |t|
      t.integer :exercise_medium_id
      t.string :illustration

      t.timestamps
    end
    add_index :exercise_medium_illustrations, :exercise_medium_id
  end
end
