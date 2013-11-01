class UsersScopes < ActiveRecord::Base
  belongs_to :user
  belongs_to :scope
  # attr_accessible :title, :body
  attr_accessible :user_id, :scope_id
end