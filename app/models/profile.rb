class Profile < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :allow_blank => false

  attr_accessible :name, :profile_scope_permissions, :profile_scope_permissions_attributes

  has_many :profile_scope_permissions
  has_many :scope_permissions, :through => :profile_scope_permissions

  accepts_nested_attributes_for :profile_scope_permissions, :allow_destroy => true

 end
