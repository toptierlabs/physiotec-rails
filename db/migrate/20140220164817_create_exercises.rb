class CreateExercises < ActiveRecord::Migration
  def up
    create_table :exercises do |t|
      t.references :subsection
      t.references :exercise_medium

      t.timestamps
    end
    add_index :exercises, :subsection_id
    add_index :exercises, :exercise_medium_id

    Exercise.create_translation_table! keywords: :text,
                                                 description: :text,
                                                 title: :string,
                                                 short_title: :string
  end

  def down
    Exercise.drop_translation_table!
    drop_table :exercises
  end
end
