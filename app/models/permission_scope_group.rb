class PermissionScopeGroup < ActiveRecord::Base
  belongs_to :permission
  belongs_to :scope_group

  attr_accessible :permission_id, :scope_group_id

  # uniqueness of (permission_id, scope_group_id) key pair
  validates :permission_id, :uniqueness => {:scope => :scope_group_id}

  # activeadmin, validates the profile when its updated
  validates :scope_group, :presence => true
  validates :permission, :presence => true, :on => :update


  def to_s
  	self.class.name
  end

end
