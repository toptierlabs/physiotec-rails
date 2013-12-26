class ScopePermission < ActiveRecord::Base

  #TODO validates uniqueness of a scope_permission

  belongs_to :permission
  belongs_to :action


  attr_accessible :permission_id, :action_id, :scopes, :scope_permission_group_scopes_attributes
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

  def check_scopes(scopes)
    result = false
    # check the scopes: at least one scope of each scope_group must be in both sp from params and self
    self_scope_groups = Hash[self.scopes
      .select!{|v| v.scope_group_id != ScopeGroup.group_clinic_id}.map{ |v| {v.id => v.scope_group_id} }]
    params_scope_groups = Hash[scopes
      .select!{|v| v.scope_group_id != ScopeGroup.group_clinic_id}.map{ |v| {v.id => v.scope_group_id} }]

    #params_scope_group must be contained in self_scope_groups
    (params_scope_groups - self_scope_groups).length == 0
  end

  def context_scope
    self.scopes.find_by_scope_group_id(ScopeGroup.group_clinic_id)
  end

  def find_scope_by_scope_group(scope_group)
    self.scopes.find_by_scope_group_id(scope_group.id)
  end

end