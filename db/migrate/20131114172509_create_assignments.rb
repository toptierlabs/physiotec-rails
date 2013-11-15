class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :assignable, polymorphic: true
      t.references :user

      t.timestamps
    end
    add_index :assignments, :user_id
  end
end