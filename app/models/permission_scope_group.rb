class PermissionScopeGroup < ActiveRecord::Base
  belongs_to :permission
  belongs_to :scope_group

  attr_accessible :permission_id, :scope_group_id

  # uniqueness of (permission_id, scope_group_id) key pair
  validates :permission_id, :uniqueness => {:scope => :scope_group_id}
  #other validations
  #validates :permission_id, :scope_group_id, :presence => true, :allow_blank => false

end
