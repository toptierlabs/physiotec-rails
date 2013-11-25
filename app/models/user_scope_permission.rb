class UserScopePermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :scope_permission
  # attr_accessible :title, :body
  attr_accessible :user_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  # validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

end