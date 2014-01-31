class UserClinic < ActiveRecord::Base
  belongs_to :user
  belongs_to :clinic
  attr_accessible :user_id, :clinic_id

  validates :clinic_id, :uniqueness => {:scope => :user_id}, presence: true
  validates :user, :clinic, presence: true
end
