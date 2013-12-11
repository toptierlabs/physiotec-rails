class ProfileScopePermission < ActiveRecord::Base
  belongs_to :profile
  belongs_to :scope_permission
  
  attr_accessible :profile_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  validates :scope_permission_id, :uniqueness => {:scope => :profile_id}
  validates :scope_permission, :profile, :presence => true
  #other validations
  #validates :profile_id, :scope_permission, :presence => true, :allow_blank => false

  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end
end
