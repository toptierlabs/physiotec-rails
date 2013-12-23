class AddTranslationToExercises < ActiveRecord::Migration
  def up
  	change_table :exercises do |t|
      t.remove :title, :short_title, :description
    end
    Exercise.create_translation_table! title: :string, short_title: :string, description: :string
  end
  def down
    Exercise.drop_translation_table!
  end
end
