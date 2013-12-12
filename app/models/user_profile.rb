class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  attr_accessible :user_id, :profile_id
  
  validates :profile_id, :uniqueness => {:scope => :user_id}
  validates :profile_id, :user_id, :presence => true  

  class SameApiLicenseValidator < ActiveModel::Validator
    def validate(record)
      if (record.profile.present? && record.user.present?)
        if record.profile.api_license_id != record.user.api_license_id
          record.errors[:base] << "must be in the same ApiLicense"
        end
      end
    end
  end

  validates_with SameApiLicenseValidator

end
