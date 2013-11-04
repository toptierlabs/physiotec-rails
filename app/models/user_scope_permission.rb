class UserScopePermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :scope_permission
  # attr_accessible :title, :body
  attr_accessible :user_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  validates :scope_permission_id, :uniqueness => {:scope => :user_id}

end
