class AddGlobalizedKeywordsToSubsectionExerciseMedia < ActiveRecord::Migration
  def up
    SubsectionExerciseMedium.create_translation_table! keywords: :text,
                                                 description: :text,
                                                 title: :string,
                                                 short_title: :string
  end

  def down
    SubsectionExerciseMedium.drop_translation_table!
  end
end
