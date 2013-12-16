class ProfileAssignment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :destination_profile, :class_name => "Profile"
  
  attr_accessible :profile_id, :destination_profile_id

  validates :destination_profile_id, :uniqueness => {:scope => :profile_id}
  #validates :profile, :destination_profile_id, :presence => true

end
