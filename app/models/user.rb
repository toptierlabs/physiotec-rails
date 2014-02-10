# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)      not null
#  last_name                :string(255)      not null
#  api_license_id           :integer          not null
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  unconfirmed_email        :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  session_token            :string(255)
#  session_token_created_at :date
#  maximum_context_cache    :string(255)
#

class User < ActiveRecord::Base
  require 'concerns/assignable'
  require 'concerns/permissiable'

  include Assignable
  include Permissiable
  

  scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

  belongs_to :api_license
  belongs_to :context,      polymorphic: true,
                            inverse_of:  :users

  has_many :user_abilities, inverse_of: :user
  has_many :abilities,      through: :user_abilities

  has_many :user_clinics
  has_many :clinics,        through: :user_clinics  

  has_many :user_profiles
  has_many :profiles,       through: :user_profiles

  has_many :categories,     as: :context

  has_many :user_contexts,  inverse_of: :user

  has_many :api_licenses,   through: :user_contexts,
                            source:  :context,
                            source_type: 'ApiLicense'
  has_many :licenses,       through: :user_contexts,
                            source:  :context,
                            source_type: 'License'
  has_many :clinics,        through: :user_contexts,
                            source:  :context,
                            source_type: 'Clinic'

  def contexts
    api_licenses + licenses + clinics
  end


  validates :email,          presence: true
  validates :first_name,     presence: true
  validates :last_name,      presence: true
  validates :api_license,    presence: true

  validates :session_token,  uniqueness: true,
                             allow_blank: true

  validates :email,          email: true
  validates :email,          uniqueness: { scope: :api_license_id }

  #validate :relation_with_license

  accepts_nested_attributes_for :user_profiles,  allow_destroy: true
  accepts_nested_attributes_for :user_abilities, allow_destroy: true


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :rememberable and :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable,
         request_keys: [:api_license_id]

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_name,
                  :last_name,
                  :api_license_id,
                  :session_token,
                  :session_token_created_at,
                  :profiles,
                  :user_profiles_attributes,
                  :profile_ids,
                  :user_profiles

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

  #name for activeadmin
  def name
    self.email + ' (' + self.first_name + ' ' + self.last_name + ')'
  end

  #display name for ActiveAdmin
  def datatype
    self.email + ' (' + self.first_name + ' ' + self.last_name + ')'
  end

  #used for active admin
  def permissions_pretty_list
    ppl = []
    self.user_scope_permissions.each do |psp|
      ppl <<  psp.datatype
    end
    ppl
  end

  def assignable_profiles
    res = []
    self.profiles.each do |p|
        res.concat(p.assignable_profiles)
    end
    #remove duplicate elements with uniq
    res.uniq
  end

  def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email], :api_license_id => warden_conditions[:api_license_id]).first
  end


  private

    def relation_with_license
      if (self.context_type == License.name) &&
      (self.context_id_changed? || self.context_type_changed?) &&
      (!self.context.can_add_users?)
        self.errors[:context] << "reached maximum users"      
      end
    end


end
