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

  validates :email, :company_name, :uniqueness => {:scope => :api_license_id}
  validates :email, :email => true
  validates :maximum_clinics, :maximum_users, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validate :validate_clinics
  def validate_clinics
    errors.add(:clinics, "too much") if clinics.length > maximum_clinics
  end

  validate :validate_users
  def validate_users
    errors.add(:users, "too much") if users.length > maximum_users
  end
  
  def license
  	self
  end
  
end
