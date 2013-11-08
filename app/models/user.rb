class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable#, :rememberable

  #Set the attributes validations
  validates :email, :first_name, :last_name, :api_license_id,
            :presence => true

  belongs_to :api_license

  # Setup accessible (or protected) attributes
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :api_license_id, :session_token,
                  :session_token_created_at, :profiles

  validates :session_token, :uniqueness => true, :allow_blank => true

  has_many :user_scope_permissions
  has_many :scope_permissions, :through=>:user_scope_permissions

  #Set the method to create new session tokens
  def new_session_token
    self.session_token = SecureRandom.urlsafe_base64
    self.session_token_created_at = DateTime.now
    self.save
    #returns the session token
    self.session_token
  end


  #An user inserts his password after he recieves a email confirmation
  def password_required?
    super if self.confirmed?
  end

  #ad role to an user
  def add_role(role)
  end

  #sets profile for current user
  def set_profile(profile)
    #profile ||= Profile::default
    #load profile roles
    #for each role self.add_role "admin"
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

  #display name for ActiveAdmin
  def display_name
    self.email + ' (' + self.first_name + ' ' + self.last_name + ')'
  end

  #a user may have many profiles

  has_many :user_profiles
  has_many :profiles, :through => :user_profiles

  accepts_nested_attributes_for :user_profiles, :allow_destroy => true



end