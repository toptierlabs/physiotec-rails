class Action < ActiveRecord::Base
  attr_accessible :name

  has_many :scope_permissions, :dependent => :destroy

  validates :name, :uniqueness => true, :presence => true

  def name_as_sym #no test for nil
  	#returns a symbol representation of the string
  	name.gsub(/\s+/, '_').parameterize.underscore.to_sym
  end

end
