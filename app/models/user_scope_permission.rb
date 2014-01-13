class UserScopePermission < ActiveRecord::Base

  @@context_value = {:own => 0, :clinic => 1, :license => 2, :api_license => 3}
  def self.context_value
    @@context_value
  end

  belongs_to :user
  belongs_to :scope_permission
  # attr_accessible :title, :body
  attr_accessible :user_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  validates :scope_permission, :user, :presence => true, :on => :update


  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

end