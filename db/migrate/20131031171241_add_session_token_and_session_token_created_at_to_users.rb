class AddSessionTokenAndSessionTokenCreatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :session_token, :string
    add_index :users, :session_token
    add_column :users, :session_token_created_at, :date
  end
end
