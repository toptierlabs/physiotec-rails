class AddTranslationToExercises < ActiveRecord::Migration
  def change
  	change_table :exercises do |t|
      t.remove :title, :short_title, :description
    end

	  create_table "exercise_translations", :force => true do |t|
	    t.integer  "exercise_id"
	    t.string   "locale",      :null => false
	    t.datetime "created_at",  :null => false
	    t.datetime "updated_at",  :null => false
	    t.string   "title"
	    t.string   "short_title"
	    t.string   "description"
	  end
  end

  add_index "exercise_translations", ["exercise_id"], :name => "index_exercise_translations_on_exercise_id"
  add_index "exercise_translations", ["locale"], :name => "index_exercise_translations_on_locale"

end
