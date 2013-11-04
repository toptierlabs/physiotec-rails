class ProfileScopePermission < ActiveRecord::Base
  belongs_to :profile
  belongs_to :scope_permission
  
  attr_accessible :profile_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  validates :scope_permission_id, :uniqueness => {:scope => :profile_id}
  #other validations
  validates :profile_id, :scope_permission, :presence => true, :allow_blank => false

end
