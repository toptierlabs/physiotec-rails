# == Schema Information
#
# Table name: licenses
#
#  id              :integer          not null, primary key
#  maximum_clinics :integer
#  maximum_users   :integer
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  api_license_id  :integer
#  company_name    :string(255)
#  users_count     :integer          default(0), not null
#

class License < ActiveRecord::Base

  scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

  before_destroy :confirm_relation_with_clinics

  attr_accessible :email,
                  :first_name,
                  :last_name,
                  :maximum_clinics,
                  :maximum_users,
                  :phone,
                  :company_name,
                  :api_license_id

  belongs_to :api_license
  
  has_many :exercises,  as:         :context,
                        dependent:  :destroy
  has_many :users,      as:         :context,
                        dependent:  :destroy,
                        inverse_of: :context
  has_many :clinics,    dependent:  :destroy,
                        inverse_of: :license

  has_many :license_categories, as:         :context,
                                class_name: 'Category',
                                dependent:  :destroy

  has_many :api_categories,     class_name: 'Category',
                                source:     'categories',
                                through:    :api_license

  def categories
    license_categories + api_categories
  end

  #model validations

  validates :email,           presence: true,
                              email: true,
                              uniqueness: { scope: :api_license_id }
  validates :company_name,    presence: true,
                              uniqueness: { scope: :api_license_id }
  validates :first_name,      presence: true
  validates :last_name,       presence: true
  validates :maximum_clinics, presence: true,
                              numericality: { only_integer: true,
                                              greater_than_or_equal_to: 0 }
  validates :maximum_users,   presence: true,
                              numericality: { only_integer: true,
                                              greater_than_or_equal_to: 0 }
  validates :phone,           presence: true
  validates :api_license,     presence: true
  validates :users_count,     presence: true


  validate :validate_clinics

  validate :validate_users

  def display_name
    self.company_name
  end

  def can_add_users?
    return users.size < maximum_users
  end

  private

    def validate_clinics
      errors.add(:clinics, "reached license maximum quota") if (maximum_clinics != 0) &&
                                          (clinics.size  > maximum_clinics)
    end
    
    def validate_users
      errors.add(:users, "reached license maximum quota") if (maximum_users != 0) &&
                                        (users.size > maximum_users)
    end

    def confirm_relation_with_clinics
      if (self.clinics.size > 0)        
        self.errors[:base] << "Can't delete a License unless it is not associated with any clinic"
        false
      end
    end
  
end
