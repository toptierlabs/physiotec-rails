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
  validates :scope_permission_id, :uniqueness => {:scope => :user_id}

  validates :scope_permission, :user, :presence => true, :on => :update


  class ScopeInContextValidator < ActiveModel::Validator
    def validate(record)
      #it should be a class      
      if (record.scope_permission.present? && record.scope_permission.context_scope.present? &&
        record.user.present? && record.user.context.present?)
        context_scope = UserScopePermission.context_value[record.scope_permission.context_scope.name.as_sym]
        context_user = nil
        if record.user.context.class == Clinic
          context_user = UserScopePermission.context_value[:clinic]
        elsif record.user.context.class == License
          context_user = UserScopePermission.context_value[:license]
        elsif record.user.context.class == ApiLicense
          context_user = UserScopePermission.context_value[:api_license]
        end
        puts '*'*80
        puts context_user
        puts context_scope
        puts record.scope_permission.context_scope.to_json
        if (context_user < context_scope)
          record.errors[:base] << "clinic scope must be greater than user's context"
        end
      end
    end
  end

  validates_with ScopeInContextValidator

  def datatype
    result = {}
    result[:action] = self.scope_permission.action.name
    result[:permission] = self.scope_permission.permission.name
    result[:scopes] = self.scope_permission.datatype
    result
  end

end