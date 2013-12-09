class License < ActiveRecord::Base

  belongs_to :api_license
  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id

  #model validations
  validates :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license_id,
            :presence => true

  validates :email, :uniqueness => true

  has_many :exercises, as: :context
  has_many :users, as: :context
  has_many :clinics


  def license
  	self
  end
  
end
