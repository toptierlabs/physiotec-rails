class ProfileAssignment < ActiveRecord::Base

	before_destroy :check_protection

  belongs_to :profile
  belongs_to :destination_profile, :class_name => "Profile"
  
  attr_accessible :profile_id, :destination_profile_id

  validates :destination_profile_id, :uniqueness => {:scope => :profile_id}
  validates :profile, :destination_profile, presence: true, :on => :update

  private

  	def check_protection
      if self.profile.protected?
        self.errors[:base] << "profile protected against deletion"
    		false
      end
  	end

end
