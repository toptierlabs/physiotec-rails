class ScopePermission < ActiveRecord::Base  
  belongs_to :permission
  belongs_to :scope

  attr_accessible :permission_id, :scope_id
  # uniqueness of the permission inside the same scope
  validates :permission_id, :uniqueness => {:scope => :scope_id}

  #has many profiles
  has_many :profile_scope_permissions
  has_many :profiles, :through=>:profile_scope_permissions

  #has many users
  has_many :user_scope_permissions
  has_many :user, :through=>:user_scope_permissions

  #display name for ActiveAdmin
  def display_name
    self.permission.name + ' (' + self.scope.name + ')'
  end

end
