class ScopeGroup < ActiveRecord::Base
  has_many :scopes
  has_many :permission_scope_groups
  attr_accessible :description, :name
end
