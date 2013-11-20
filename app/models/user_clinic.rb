class UserClinic < ActiveRecord::Base
  belongs_to :user
  belongs_to :clinic
  attr_accessible :user_id, :clinic_id
end
