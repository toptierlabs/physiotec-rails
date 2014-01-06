class UserProfile < ActiveRecord::Base

  after_create :set_user_scope_permissions

  belongs_to :user
  belongs_to :profile

  attr_accessible :user_id, :profile_id
  
  validates :profile_id, :uniqueness => {:scope => :user_id}
  validates :profile_id, :user_id, :presence => true  

  class SameApiLicenseValidator < ActiveModel::Validator
    def validate(record)
      if (record.profile.present? && record.user.present?) &&
        (record.profile.api_license_id.present? && record.user.api_license_id.present?)
        if record.profile.api_license_id != record.user.api_license_id
          record.errors[:base] << "must be in the same ApiLicense"
        end
      end
    end
  end

  validates_with SameApiLicenseValidator

  private

    #called when there are new profiles asssigned to this user
    def set_user_scope_permissions
        new_scope_permission_ids = []
        # new user scope_permissions
        new_scope_permission_ids = self.profile.scope_permission_ids 
        # current user scope_permissions
        u_sp = self.user.scope_permission_ids# - new_scope_permission_ids
        add_scope_permission_ids = new_scope_permission_ids - u_sp
        self.user.scope_permissions << ScopePermission
                                  .includes(:scopes=>:scope_group)
                                  .where(id:add_scope_permission_ids)   
    end

end
