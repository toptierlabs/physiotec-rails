class AddMaximumContextCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maximum_context_cache_id, :integer, null: false, default: 1
  end
end
