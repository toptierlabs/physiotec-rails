class License < ActiveRecord::Base

  belongs_to :api_license
  
  has_many :exercises, as: :context
  has_many :users, as: :context
  has_many :clinics

  #model validations
  validates :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id,
            :presence => true

  validates :email, :uniqueness => {:scope => :api_license_id}

  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id


  def license
  	self
  end
  
end
