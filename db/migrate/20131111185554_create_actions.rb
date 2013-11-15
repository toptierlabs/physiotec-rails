class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name,            :null => false, :default => ""
      t.timestamps
    end

    add_index :actions, :name,   :unique => true
  end
end
