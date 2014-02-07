class CreateUserContexts < ActiveRecord::Migration
  def change
    create_table :user_contexts do |t|
      t.references :user
      t.references :context, polymorphic: true

      t.timestamps
    end
    add_index :user_contexts, :user_id
    add_index :user_contexts, [:context_id, :context_type]
  end
end
