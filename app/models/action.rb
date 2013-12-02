class Action < ActiveRecord::Base
  attr_accessible :name

  has_many :scope_permissions, :dependent => :destroy

  validates :name, :uniqueness => true
end
