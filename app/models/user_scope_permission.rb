class UserScopePermission < ActiveRecord::Base

  @@context_value = {:own => 0, :clinic => 1, :license => 2, :api_license => 3}
  def self.context_value
    @@context_value
  end

  belongs_to :user
  belongs_to :scope_permission, inverse_of: :user_scope_permissions

  attr_accessible :user_id, :scope_permission_id

  validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  validates :user,                presence: true
  validates :scope_permission,    presence: true


  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

end