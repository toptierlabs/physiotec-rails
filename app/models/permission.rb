class Permission < ActiveRecord::Base
  attr_accessible :name, :permission_scope_groups

  has_many :permission_scope_groups
  has_many :scope_groups, :through => :permission_scope_groups

  accepts_nested_attributes_for :permission_scope_groups, :allow_destroy => true

end
