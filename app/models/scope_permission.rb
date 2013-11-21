class ScopePermission < ActiveRecord::Base

  #TODO validates uniqueness of a scope_permission

  belongs_to :permission
  belongs_to :action


  attr_accessible :permission_id, :action_id, :scopes, :scope_permission_group_scopes_attributes
  # uniqueness of the permission inside the same scope

  #has many profiles
  has_many :profile_scope_permissions
  has_many :profiles, :through=>:profile_scope_permissions

  #has many users
  has_many :user_scope_permissions
  has_many :user, :through=>:user_scope_permissions

  #has many scopes, the validation that one Scopepermission
  #can have just one scope is in the scope_permission_group_scope model

  has_many :scope_permission_group_scopes
  has_many :scopes, :through => :scope_permission_group_scopes

  accepts_nested_attributes_for :scope_permission_group_scopes, :allow_destroy => true

  #validates :permission_id, :uniqueness => {:scope => :scope_id}

  #can't be undefined
  validates :permission, :action, :presence => true

  
  class GoodnessValidator < ActiveModel::Validator
    def validate(record)
      record.scope_permission_group_scopes.each do | spgs |
        if !record.permission.permission_scope_groups.where('scope_group_id = ?', spgs.scope.scope_group.id).exists?
          record.errors[:base] << "invalid scopes for the current permission"
        end
      end      
    end
  end
  validates_with GoodnessValidator

  #display name for ActiveAdmin
  def datatype
    #concatenates the scopes names linked with the instance
    display_scopes = []
    self.scopes.each do | spgs |
      display_scopes << spgs.name
    end
    display_scopes
  end

  def display_name
    #concatenates the scopes names linked with the instance
    display_scopes = ''
    self.scopes.each do | spgs |
      display_scopes += spgs.name + ', '
    end
    self.action.name + ' ' + self.permission.name + ' (' + display_scopes[0..-3] + ')'
  end

    # Validation: selected scope must be in at least one of the scope_group
  # associated with the permission through permission_scope_groups
  # include ActiveModel::Validations

  # class ScopeGroupValidator < ActiveModel::EachValidator

  #   def validate_each( record, attribute, value )
  #     #record is current ScopePermissionGroupScope object, value is a scope object
  #     puts 'entra'
  #     puts record.to_json
  #     puts value.to_json
  #     if ( record.scope_permission != nil && value != nil )
  #       puts 'entra 2'
  #       if !record.scope_permission.permission.permission_scope_groups.where('scope_group_id = ?', value.scope_group.id).exists?
  #         record.errors.add attribute, "invalid scope for the selected permission"
  #         puts 'entra 3'
  #       end
  #     end
  #   end

  # end

  # validates :scopes, :scope_group => true

end