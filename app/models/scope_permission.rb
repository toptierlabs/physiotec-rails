class ScopePermission < ActiveRecord::Base  
  belongs_to :permission
  belongs_to :scope

  attr_accessible :permission_id, :scope_id
  # uniqueness of the permission inside the same scope
  validates :permission_id, :uniqueness => {:scope => :scope_id}

  #has many profiles
  has_many :profile_scope_permissions
  has_many :profiles, :through=>:profile_scope_permissions

  #has many users
  has_many :user_scope_permissions
  has_many :user, :through=>:user_scope_permissions

  #can't be undefined
  validates :permission_id, :scope_id, :presence => true

  #display name for ActiveAdmin
  def display_name
    self.permission.name + ' (' + self.scope.name + ')'
  end

  # Validation: selected scope must be in at least one of the scope_group
  # associated with the permission through permission_scope_groups
  include ActiveModel::Validations

  class ScopeGroupValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if (record.permission != nil && record.scope != nil && value != nil )
        if !record.permission.permission_scope_groups.where('scope_group_id=?', value.scope_group.id).exists?
           record.errors.add attribute, "invalid scope for the selected permission"
        end
      end
    end
  end

  validates :scope, :scope_group => true



end