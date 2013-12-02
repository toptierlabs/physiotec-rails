class ScopeGroup < ActiveRecord::Base
  has_many :scopes, :dependent => :destroy
  #has_many :permission_scope_groups
  has_many :scope_permissions, :dependent => :destroy

  validates :name, :uniqueness => true

  attr_accessible :description, :name, :api_license_id
  
end
