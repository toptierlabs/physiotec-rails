class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title
      t.string :description
      t.references :context, :polymorphic => true
      t.references :license
      t.references :owner

      t.timestamps
    end
    add_index :exercises, :owner_id
  end
end
