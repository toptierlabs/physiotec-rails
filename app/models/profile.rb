class Profile < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :allow_blank => false

  attr_accessible :name, :profile_scope_permissions,
                  #for nested compatibility
                  :scope_permissions_attributes, :source_profiles

  has_many :profile_scope_permissions
  has_many :scope_permissions, :through => :profile_scope_permissions

  accepts_nested_attributes_for :profile_scope_permissions, :allow_destroy => true

  def permissions_pretty_list
  	ppl = []
  	self.profile_scope_permissions.each do |psp|
  		ppl <<  psp.display_name
  	end

  	ppl.join(', ')
  end

  # a profile may have multiple profiles, this relation is used when a
  # new user is created, or a user wants to assign to another user a profile

  has_many :profile_assignment
  has_many :destination_profiles, :through => :profile_assignment

  accepts_nested_attributes_for :profile_assignment, :allow_destroy => true

  def self.license_administrator_profile
    self.find_by_name("License administrator")
  end

 end
