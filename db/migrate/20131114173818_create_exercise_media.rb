class CreateExerciseMedia < ActiveRecord::Migration
  def change
    create_table :exercise_media do |t|
      t.string :title
      t.string :description
      t.references :context, :polymorphic => true
      t.references :license
      t.references :owner

      t.timestamps
    end
    add_index :exercise_media, :owner_id
  end
end
