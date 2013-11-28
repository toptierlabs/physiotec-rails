class Permission < ActiveRecord::Base
  attr_accessible :name, :permission_scope_groups, :permission_scope_groups_attributes, :api_license_id

  #has many scope_permissions
  has_many :scope_permissions

  #has many scope_groups
  has_many :permission_scope_groups
  has_many :scope_groups, :through => :permission_scope_groups
  #nested attributes
  accepts_nested_attributes_for :permission_scope_groups, :allow_destroy => true

  validates :name, :uniqueness => {:scope => :api_license_id}
  
  def sym_name #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

end
