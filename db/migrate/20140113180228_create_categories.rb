class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.references :owner
      t.references :context,     :null => false,
                                 :polymorphic => true

      t.timestamps
    end
    Category.create_translation_table! :name => :string

    add_index :categories, :owner_id
    add_index :categories, [:context_type, :context_id]
  end

  def down
    drop_table :categories
    Category.drop_translation_table!
  end
end
