class ProfileScopePermission < ActiveRecord::Base

  before_destroy :check_protection
  before_save :assign_protection

  belongs_to :profile
  belongs_to :scope_permission
  
  attr_accessible :profile_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  validates :scope_permission_id, :uniqueness => {:scope => :profile_id}
  validates :scope_permission, :profile, :presence => true, :on => :update

  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

  private

    def check_protection
      if self.protected?
        self.errors[:base] << "profile protected against deletion"
        false
      end
    end

    def assign_protection
      self.protected = self.profile.protected?
    end

end
