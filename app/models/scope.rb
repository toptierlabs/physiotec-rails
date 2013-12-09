class Scope < ActiveRecord::Base
  belongs_to :scope_group
  has_many :scope_permission_group_scopes, :dependent => :destroy

  #uniqueness of the name inside a scope group
  validates :name, :uniqueness => { :scope => :scope_group_id }

  attr_accessible :name, :scope_group_id

  def name_as_sym #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

end