class UserScopePermission < ActiveRecord::Base

  @@context_value = {:own => 0, :clinic => 1, :license => 2, :api_license => 3}
  def self.context_value
    @@context_value
  end

  belongs_to :user
  belongs_to :scope_permission
  # attr_accessible :title, :body
  attr_accessible :user_id, :scope_permission_id
  # uniqueness of the permission inside the same scope
  # validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  validates :scope_permission_id, :uniqueness => {:scope => :user_id}
  validates :scope_permission, :user, :presence => true

  class SameApiLicenseValidator < ActiveModel::Validator
    def validate(record)
      if (record.scope_permission.present? && record.user.present?)
        if record.scope_permission.permission.api_license_id != record.user.api_license_id
          record.errors[:base] << "must be in the same ApiLicense"
        end
      end
    end
  end

  class ScopeInContextValidator < ActiveModel::Validator
    def validate(record)
      #it should be a class      
      if (record.scope_permission.present? && record.user.present? && record.user.context.present?)
        context_scope = UserScopePermission.context_value[record.scope_permission.context_scope.name.as_sym]
        context_user = nil
        if record.user.context.respond_to?(:clinic)
          context_user = :clinic
        elsif record.user.context.respond_to?(:license)
          context_user = :license
        elsif record.user.context.respond_to?(:api_license)
          context_user = :api_licence
        end
        if (context_scope != :own) && (context_scope < context_user)
          record.errors[:base] << "clinic scope must be greater than user's context"
        end
      end
    end
  end

  class ClinicScopeValidator < ActiveModel::Validator
    def validate(record)
      if record.scope_permission.present?
        context_scope = record.scope_permission.context_scope.name.as_sym
        if (context_scope != :nil)
          record.errors[:base] << "user alredy has a clinic scope"
        end
      end
    end
  end

  validates_with SameApiLicenseValidator
  validates_with ScopeInContextValidator

  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

end