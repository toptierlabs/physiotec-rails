class License < ActiveRecord::Base

  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone
  
end
