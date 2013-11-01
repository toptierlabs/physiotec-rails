class Profile < ActiveRecord::Base
  attr_accessible :name
  has_many :profiles_scopes
  has_many :scopes, :through=>:profiles_scopes
end
