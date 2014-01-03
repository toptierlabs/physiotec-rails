class ScopeGroup < ActiveRecord::Base

  before_destroy :confirm_relation_with_permissions

  has_many :scopes, :dependent => :destroy

  has_many :permission_scope_group, :dependent => :destroy

  validates :name, :uniqueness => true
  validates :name, :presence => true

  attr_accessible :description, :name

  def self.group_clinic_id
    @@scope_group_clinic ||= self.find_by_name("Context").id
  end

  private

    def confirm_relation_with_permissions
      if (self.permission_scope_group.present? || self.scopes.present?)
        self.errors[:base] << "Can't delete a Scope Group unless it is not associated with any permission and any scope"
        false
      end
    end

end
