class Scope < ActiveRecord::Base
  belongs_to :scope_group
  has_many :scope_permission_group_scopes, :dependent => :destroy

  #uniqueness of the name inside a scope group
  validates :name, :uniqueness => { :scope => :scope_group_id }, :presence => true
  validates :name, :presence => true

  attr_accessible :name, :scope_group_id

  before_destroy :clean_scope_group

  def name_as_sym #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

  private

    def clean_scope_group
      if self.scope_group.scopes.length == 1
        self.scope_group.destroy
      end
    end

end