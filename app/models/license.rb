class License < ActiveRecord::Base

  scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

  before_destroy :confirm_relation_with_clinics

  attr_accessible :email, :first_name, :last_name, :maximum_clinics, :maximum_users,
                  :phone, :company_name, :api_license_id

  belongs_to :api_license
  
  has_many :exercises, as: :context, :dependent => :destroy
  has_many :users, as: :context, :dependent => :destroy
  has_many :clinics, :dependent => :destroy

  #model validations
  validates :email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone,
            :api_license, :company_name,
            :presence => true

  validates :email, :company_name, :uniqueness => {:scope => :api_license_id}
  validates :email, :email => true
  validates :maximum_clinics, :maximum_users, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }


  validate :validate_clinics, :on => :update

  validate :validate_users

  def license
    self
  end

  #returns object class name, required for returning user's context
  def entity
    self.class.name
  end

  def display_name
    self.company_name
  end

  private

    def validate_clinics
      errors.add(:clinics, "too much") if (maximum_clinics != 0) &&
                                          (clinics.size  >= maximum_clinics)
    end
    
    def validate_users
      errors.add(:users, "too much") if (maximum_users != 0) &&
                                        (self.users.size >= maximum_users)
    end

    def confirm_relation_with_clinics
      if (self.clinics.length > 0)        
        self.errors[:base] << "Can't delete a License unless it is not associated with any clinic"
        false
      end
    end
  
end
