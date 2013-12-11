class ScopeGroup < ActiveRecord::Base
  belongs_to :api_license
  has_many :scopes, :dependent => :destroy

  #has_many :permission_scope_groups
  has_many :scope_permissions, :dependent => :destroy

  validates :name, :uniqueness => {:scope => :api_license_id}, :presence => true

  attr_accessible :description, :name, :api_license_id
  

  def self.group_clinic_id
  	self.find_by_name("Context").id
  end
end
