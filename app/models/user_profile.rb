# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  profile_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserProfile < ActiveRecord::Base

  belongs_to :user
  belongs_to :profile

  attr_accessible :user_id,
                  :profile_id  
  
  validates :profile,    presence: true 
  validates :user,       presence: true 
  validates :profile_id, uniqueness: { scope: :user_id }

end
