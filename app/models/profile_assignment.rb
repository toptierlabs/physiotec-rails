class ProfileAssignment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :destination_profile, :class_name => "Profile"
  
  attr_accessible :profile, :destination_profile
end
