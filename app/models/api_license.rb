class ApiLicense < ActiveRecord::Base
  
  #Generates api keys before the model is created
  before_validation :generate_api_keys, :on => :create

  attr_accessible :description, :name, :licenses

  has_many :users, :dependent => :destroy
  has_many :licenses, :dependent => :destroy

  #Set the attributes validations
  validates :name, :description,
            :public_api_key, :secret_api_key, :presence => true

  validates :name, :public_api_key, :secret_api_key, :uniqueness => true
  
  def api_license
    self
  end

  #returns object class name, required for returning user's context
  def entity
    self.class.name
  end

  private

    def generate_api_keys
    if Rails.env.development?
      self.public_api_key = "PUBLIC_API_KEY_" + self.name.parameterize.underscore
      self.secret_api_key = "SECRET_API_KEY_" + self.name.parameterize.underscore
    else
      self.public_api_key = SecureRandom.urlsafe_base64
      self.secret_api_key = SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
    end
  end

end
