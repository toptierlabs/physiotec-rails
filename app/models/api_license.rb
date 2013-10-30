class ApiLicense < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name, :presence=>true
  validates :description, :presence=>true

  has_many :users
end
