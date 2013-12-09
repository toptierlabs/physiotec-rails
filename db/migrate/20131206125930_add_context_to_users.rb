class AddContextToUsers < ActiveRecord::Migration
  def up
  	change_table :users do |t|
      t.references :context, :polymorphic => true
      t.index :context_id
      t.index :context_type
    end
  end

  def down
  	change_table :users do |t|
      t.remove_references :context, :polymorphic => true
    end
  end

end
