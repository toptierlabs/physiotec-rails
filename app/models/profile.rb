class Profile < ActiveRecord::Base


  attr_accessible :name, :profile_scope_permissions, :destination_profiles,
                  #for nested compatibility
                  :scope_permissions_attributes, :source_profiles, :profile_scope_permissions_attributes, :api_license_id

  has_many :profile_scope_permissions, :dependent => :destroy
  has_many :scope_permissions, :through => :profile_scope_permissions

  validates :name, :presence => true, :allow_blank => false
  validates :name, :uniqueness => {:scope => :api_license_id}

  accepts_nested_attributes_for :profile_scope_permissions, :allow_destroy => true

  def permissions_pretty_list
  	ppl = []
  	self.profile_scope_permissions.each do |psp|
  		ppl <<  psp.datatype
  	end
  	ppl
  end

  # a profile may have multiple profiles, this relation is used when a
  # new user is created, or a user wants to assign to another user a profile

  has_many :profile_assignment, :dependent => :destroy
  has_many :destination_profiles, :through => :profile_assignment

  accepts_nested_attributes_for :profile_assignment, :allow_destroy => true

  def self.license_administrator_profile
    self.find_by_name("License administrator")
  end

  # after_save :create_scope

  # def create_scope    
  #   scope = Scope.find_by_name(self.name_was) if self.name_changed?
  #   if !scope.nil?
  #     scope.name = self.name
  #     scope.save
  #   else
  #     sg_id =  ScopeGroup.find_by_name("Profiles")
  #     Scope.create(name: self.name, scope_group_id: sg_id)
  #   end
  # end

  # returns an array of arrays with the name of the destination profiles as elements
  def hash_formatter(permission, action, s)
    {:permission => permission, :action => action, :scopes => [s.parameterize.underscore.to_sym] }
  end

  def permission_scopes_list
    result = []
    self.destination_profiles.each do |p|
      result << hash_formatter(:profile, :assign, p.name)
      result << hash_formatter(:profile, :unassign, p.name)
    end
    result
  end


  def assignable_profiles_datatype
    res = []
    self.destination_profiles.each do | p |
      res << p.as_json(:only=>[:id, :name])
    end
    res.uniq
  end

 end
