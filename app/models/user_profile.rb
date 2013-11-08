class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  attr_accessible :user, :profile
end
