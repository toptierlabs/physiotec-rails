class ScopePermissionGroupScope < ActiveRecord::Base
  belongs_to :scope_permission
  belongs_to :scope

  attr_accessible :scope_permission_id, :scope_id

  #validates :scope_permission_id, :scope_id, :presence => true
  validates :scope_id, :uniqueness => {:scope => :scope_permission_id}

  
end
