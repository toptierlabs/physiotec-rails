class User < ActiveRecord::Base

  rolify
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #Set the attributes validations
  validates :email, :first_name, :last_name, :api_license_id,
            :presence => true

  belongs_to :api_license

  # Setup accessible (or protected) attributes
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :api_license_id

  #The user inserts the password after he recieves a email confirmation
  def password_required?
    super if self.confirmed?
  end 

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def self.find_by_unhashed_confirmation_token(confirmation_token)
    original_token = confirmation_token
    confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
    confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    if !confirmable.persisted? && Devise.allow_insecure_token_lookup
      confirmable = find_or_initialize_with_error_by(:confirmation_token, original_token)
    end

    confirmable
  end 

end