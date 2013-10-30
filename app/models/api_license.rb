class ApiLicense < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :api_license_admins
end
