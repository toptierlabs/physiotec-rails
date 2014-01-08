class ScopePermission < ActiveRecord::Base

  #TODO validates uniqueness of a scope_permission

  belongs_to :permission
  belongs_to :action


  attr_accessible :permission_id, :action_id, :scopes,
                  :scope_permission_group_scopes_attributes, :scope_ids
  # uniqueness of the permission inside the same scope

  #has many profiles
  has_many :profile_scope_permissions, :dependent => :destroy
  has_many :profiles, :through=>:profile_scope_permissions

  #has many users
  has_many :user_scope_permissions, :dependent => :destroy
  has_many :user, :through=>:user_scope_permissions

  #has many scopes, the validation that one Scopepermission
  #can have just one scope is in the scope_permission_group_scope model

  has_many :scope_permission_group_scopes
  has_many :scopes, :through => :scope_permission_group_scopes

  accepts_nested_attributes_for :scope_permission_group_scopes, :allow_destroy => true

  #can't be undefined
  validates :permission, :action, :presence => true

  
  class ScopesInScopeGroupsValidator < ActiveModel::Validator
    def validate(record)
      record.scopes.each do | spgs |

        if spgs.scope_group.present? && record.permission.permission_scope_groups.where('scope_group_id = ?', spgs.scope_group.id).blank?
          record.errors[:base] << "invalid scopes for the current permission"
        end
      end      
    end
  end
  
  #validates_with ClinicScopeValidator
  validates_with ScopesInScopeGroupsValidator

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

  def check_scopes(scopes_p)
    result = false
    #checks the context scope
    user_context = self.scopes.find_by_scope_group_id(ScopeGroup.group_clinic_id)
    scope_context = scopes_p.find_by_scope_group_id(ScopeGroup.group_clinic_id)
    if user_context.present? && scope_context.present? 
      if UserScopePermission.context_value[user_context.name.as_sym] < UserScopePermission.context_value[scope_context.name.as_sym]
        return false
      end
    end
    # check the scopes: at least one scope of each scope_group must be in both sp from params and self
    aux_self_sg = self.scopes.select{|v| v.scope_group_id != ScopeGroup.group_clinic_id}
    aux_params_sg = scopes_p.select{|v| v.scope_group_id != ScopeGroup.group_clinic_id}

    if aux_self_sg.present? && aux_params_sg.present?
      self_scope_groups = Hash[aux_self_sg.map{ |v| [v.id, v.scope_group_id] }]
      params_scope_groups = Hash[aux_params_sg.map{ |v| [v.id, v.scope_group_id] }]

      #params_scope_group must be contained in self_scope_groups
      if (self_scope_groups.keys.uniq & params_scope_groups.keys.uniq).present?
        return true if (self_scope_groups.values.uniq - params_scope_groups.values.uniq).size == 0
      else
        false
      end
    else
      false
    end
  end

  def context_scope
    self.scopes.find_by_scope_group_id(ScopeGroup.group_clinic_id)
  end

  def find_scope_by_scope_group(scope_group)
    self.scopes.find_by_scope_group_id(scope_group.id)
  end

end