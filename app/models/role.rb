class Role < ActiveRecord::Base
  has_and_belongs_to_many :api_license_admin, :join_table => :api_license_admins_roles
  belongs_to :resource, :polymorphic => true
  
  scopify
end
