class ApiLicense < ActiveRecord::Base
  
  #Generates api keys before the model is created
  before_validation :generate_api_keys, :on => :create

  attr_accessible :description, :name, :public_api_key, :secret_api_key

  #Set the attributes validations
  validates :name, :description,
            :public_api_key, :secret_api_key, :presence => true

  validates :public_api_key, :secret_api_key, :uniqueness => true


  has_many :users


  def generate_api_keys
  	self.public_api_key = SecureRandom.urlsafe_base64
  	self.secret_api_key = SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
  end

end
