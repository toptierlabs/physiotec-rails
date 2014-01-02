class Permission < ActiveRecord::Base
  
  #has many scope_permissions
  has_many :scope_permissions, :dependent => :destroy

  #has many scope_groups
  has_many :permission_scope_groups, :dependent => :destroy
  has_many :scope_groups, :through => :permission_scope_groups
  #nested attributes
  accepts_nested_attributes_for :permission_scope_groups, :allow_destroy => true

  validates :name, :uniqueness => true
  validates :name, :presence => true

  attr_accessible :name, :permission_scope_groups, :permission_scope_groups_attributes,
                  :model_name
  
  def name_as_sym #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

   def self.profile
    self.find_by_name("Profile")
   end

end
