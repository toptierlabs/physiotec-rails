class Scope < ActiveRecord::Base
  belongs_to :scope_group
  has_many :scope_permissions

  #uniqueness of the name inside a scope group
  validates :name, :uniqueness => {:scope => :scope_group_id}

  attr_accessible :name, :scope_group_id

end
