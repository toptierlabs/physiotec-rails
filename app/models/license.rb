class License < ActiveRecord::Base

  belongs_to :api_license
  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id

  #model validations
  validates :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id,
            :presence => true

  validates :email, :uniqueness => true
  
end
