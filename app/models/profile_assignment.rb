class ProfileAssignment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :destination_profile, :class_name => "Profile"
  
  attr_accessible :profile_id, :destination_profile_id
end
