class Scope < ActiveRecord::Base
  before_destroy :confirm_relation_with_scope_permissions
  after_destroy :clean_scope_group

  before_save :underscore_name

  belongs_to :scope_group
  has_many :scope_permission_group_scopes, :dependent => :destroy

  #uniqueness of the name inside a scope group
  validates :name, :uniqueness => { :scope => :scope_group_id }
  validates :name, :presence => true

  attr_accessible :name, :scope_group_id

  def name_as_sym #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

  private

    def clean_scope_group
      if self.scope_group.scopes.length == 0
        self.scope_group.destroy
      end
    end

    def confirm_relation_with_scope_permissions
      if (self.scope_permission_group_scopes.length > 0)        
        self.errors[:base] << "Can't delete a Scope unless it is not associated with any Scope Permission"
        false
      end
    end

    def underscore_name
      self.name = self.name.underscore
    end

end