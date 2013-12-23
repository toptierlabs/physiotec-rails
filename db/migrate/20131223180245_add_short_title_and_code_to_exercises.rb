class AddShortTitleAndCodeToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :short_title, :string
    add_column :exercises, :code, :string
  end
end
