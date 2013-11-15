class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  attr_accessible :user_id, :profile_id
  
  validates :profile_id, :uniqueness => {:scope => :user_id}
end
