class User < ActiveRecord::Base

  include PermissionHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable#, :rememberable

  #Set the attributes validations
  validates :email, :first_name, :last_name, :api_license_id,
            :presence => true

  belongs_to :api_license

  # Can be blank
  belongs_to :license


  # Setup accessible (or protected) attributes
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :api_license_id, :session_token,
                  :session_token_created_at, :profiles,
                  :user_profiles_attributes, :user_scope_permissions_attributes

  validates :session_token, :uniqueness => true, :allow_blank => true

  has_many :user_scope_permissions
  has_many :scope_permissions, :through=>:user_scope_permissions
  accepts_nested_attributes_for :user_scope_permissions, :allow_destroy => true

  #has many clinics
  has_many :user_clinics
  has_many :clinics, :through=>:user_clinics
  accepts_nested_attributes_for :user_clinics, :allow_destroy => true

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
  def datatype
    self.email + ' (' + self.first_name + ' ' + self.last_name + ')'
  end

  #a user may have many profiles

  has_many :user_profiles
  has_many :profiles, :through => :user_profiles

  accepts_nested_attributes_for :user_profiles, :allow_destroy => true

  # After create (the method is executed once) creates the user_scope_permissions
  # for the user, given the profiles
  after_create :assign_scopes_permissions

  def assign_scopes_permissions
    self.profiles.each do | profile |
      #gets the permissions and  scopes for the current profile
      profile.scope_permissions.each do | scope_permission |
        #creates the relation unless it alredy exists
        if UserScopePermission.where(user_id: self.id, scope_permission_id: scope_permission.id).empty?
          UserScopePermission.create(user_id: self.id, scope_permission_id: scope_permission.id)
        end
      end
    end
  end

  def permissions_pretty_list
    ppl = []
    self.user_scope_permissions.each do |psp|
      ppl <<  psp.datatype
    end
    puts '/'*100
    puts ppl.to_json
    ppl
  end

  def hash_formatter(permission, action, s)
    {:permission => permission, :action => action, :scopes => s }
  end

  def scope_permissions_list
    #creates a list with the scope_permissions linked with the user
    res = scope_permissions.joins(:permission,:action,:scopes).map do |p|
      scope_list = p.scopes.map{ |s| s.name.parameterize.underscore.to_sym }
      hash_formatter(p.permission.name.parameterize.underscore.to_sym, p.action.name.parameterize.underscore.to_sym, scope_list)
    end

    #creates a list with the scope_permissions related to profile assignment linked with the profiles
    profiles.each do |p|
      p.permission_scopes_list.each do |s|
        res << s
      end
    end
    res
  end

  # Returns an array of arrays witch each one contains the
  # following information about a permission and its scopes:
  # result = [[permission.name, action.name, *scopes]]

  # def relevant_rules_for_match
  #   result = []
  #   auxiliar = []
  #   user_scope_permissions.each do | usp |
  #     #First push the permission and then the action
  #     auxiliar << usp.scope_permission.permission.name
  #     auxiliar << usp.scope_permission.action.name
  #     #Pushes the name of the linked scopes
  #     usp.scope_permission.scopes.each do | scope |
  #       auxiliar << scope.name
  #     end
  #     result << auxiliar
  #     auxiliar = []
  #   end
  #   result
  # end



end