class License < ActiveRecord::Base

  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users,
                  :phone, :company_name, :api_license_id

  belongs_to :api_license
  
  has_many :exercises, as: :context
  has_many :users, as: :context
  has_many :clinics

  #model validations
  validates :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone, :api_license,
            :presence => true

  validates :email, :uniqueness => {:scope => :api_license_id}
  validates :email, :email => true

  

  def license
  	self
  end
  
end
