class AddMaximumContextCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maximum_context_cache, :integer, null: false, default: 0
  end
end
