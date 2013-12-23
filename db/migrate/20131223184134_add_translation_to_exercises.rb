class AddTranslationToExercises < ActiveRecord::Migration
  def up
    Exercise.create_translation_table! title: :string, short_title: :string, description: :string
  end
  def down
    Exercise.drop_translation_table!
  end
end
