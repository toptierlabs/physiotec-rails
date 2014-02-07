# == Schema Information
#
# Table name: api_licenses
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  public_api_key :string(255)
#  secret_api_key :string(255)
#

class ApiLicense < ActiveRecord::Base
  
  #Generates api keys before the model is created
  before_validation :generate_api_keys, :on => :create

  attr_accessible :description,
                  :name,
                  :licenses

  has_many :languages,      dependent: :destroy
  has_many :api_users,      dependent: :destroy,
                            class_name: "User"
  has_many :users,          as: :context,
                            inverse_of: :context
  has_many :profiles,       dependent: :destroy
  has_many :clinics,        dependent: :destroy
  has_many :licenses,       dependent: :destroy
  has_many :exercises,      dependent: :destroy
  has_many :sections,       dependent: :destroy
  has_many :api_categories, as:        :context,
                            dependent: :destroy,
                            class_name: "Category"

  has_many :license_categories, through: :licenses
  has_many :clinic_categories,  through: :clinics,
                                source:  :categories
  has_many :user_categories,    through: :users,
                                source:  :categories
  
  def categories
    api_categories + license_categories +
    clinic_categories + user_categories
  end

  #Set the attributes validations
  validates :name,
            :description,
            :public_api_key,
            :secret_api_key,   presence: true

  validates :name,
            :public_api_key,
            :secret_api_key,   :uniqueness => true
  
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
      self.public_api_key = "PUBLIC_API_KEY_#{self.name.parameterize.underscore}" 
      self.secret_api_key = "SECRET_API_KEY_#{self.name.parameterize.underscore}"
    else
      self.public_api_key = SecureRandom.urlsafe_base64
      self.secret_api_key = SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
    end
  end

end
