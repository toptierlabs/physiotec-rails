class ScopePermissionGroupScope < ActiveRecord::Base
  belongs_to :scope_permission, inverse_of: :scope_permission_group_scopes
  belongs_to :scope

  attr_accessible :scope_permission_id, :scope_id

  validates :scope_id, uniqueness: { scope: :scope_permission_id }

  validates :scope_permission, presence: true
  validates :scope,            presence: true
  
end
