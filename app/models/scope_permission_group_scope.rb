class ScopePermissionGroupScope < ActiveRecord::Base
  belongs_to :scope_permission
  belongs_to :scope

  attr_accessible :scope_permission_id, :scope_id

  #validates :scope_permission_id, :scope_id, :presence => true
  validates :scope_id, :uniqueness => {:scope => :scope_permission_id}
  #validates :scope_permission, :scope, :presence => true

  class SameApiLicenseValidator < ActiveModel::Validator
    def validate(record)
      if (record.scope_permission.present? && record.scope.present?)
        if record.scope_permission.permission.api_license_id != record.scope.scope_group.api_license_id
          record.errors[:base] << "must be in the same ApiLicense"
        end
      end
    end
  end

  validates_with SameApiLicenseValidator

  
end
