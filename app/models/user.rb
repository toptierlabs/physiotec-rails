class User < ActiveRecord::Base

	include PermissionHelper
	include AssignableHelper

	scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
				 :recoverable, :trackable, :confirmable,#, :rememberable, :validatable
				 request_keys: [:api_license_id]

	#Set the attributes validations
	validates :email, :first_name, :last_name, :api_license, :context,
						:presence => true

	validates :session_token, :uniqueness => true, :allow_blank => true

	validates :email, :email => true

	validates :email, :uniqueness => {:scope => :api_license_id}

	validates :context, associated: {:message => "reached maximum users"},
											:if => lambda { (self.context_type == License.name) &&
																			(self.context_id_changed? ||
																			 self.context_type_changed?) }

	belongs_to :api_license
	belongs_to :context, :polymorphic => true  

	has_many :user_scope_permissions
	has_many :scope_permissions, :through=>:user_scope_permissions
	accepts_nested_attributes_for :user_scope_permissions, :allow_destroy => true

	#has many clinics
	has_many :user_clinics
	has_many :clinics, :through=>:user_clinics
	accepts_nested_attributes_for :user_clinics, :allow_destroy => true

	#a user may have many profiles, also it creates the user_scope_permissions
	# for the user, given the profiles
	has_many :user_profiles
	has_many :profiles, :through => :user_profiles

	accepts_nested_attributes_for :user_profiles, :allow_destroy => true

	# Setup accessible (or protected) attributes
	attr_accessible :email, :password, :password_confirmation, :remember_me,
									:first_name, :last_name, :api_license_id, :session_token,
									:session_token_created_at, :profiles,
									:user_profiles_attributes, :user_scope_permissions_attributes,
									:context_id, :context_type, :profile_ids, :user_profiles, :scope_permission_ids

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

	def api_administrator?
		self.profiles.where(id: Profile.api_license_administrator_profile.id).present?
	end


	def assignable_profiles
		res = []
		self.profiles.each do |p|
				res.concat(p.assignable_profiles)
		end
		#remove duplicate elements with uniq
		res.uniq
	end

	def scope_permission_for_read(permission)
		# Get the permission for the given class_name
		result = nil
		self.scope_permissions.includes(:permission,:action).each do |v|
			if (v.permission.name_as_sym == permission) && (v.action.name_as_sym == Action.read_action)
				result = v
			end
			break if result
		end
		result
	end

	# returns all the contexts related to the user
	def contexts(params = nil)
		if self.context.class == Clinic

			[self.context] if params.blank? || (params[:only] == Clinic.name.as_sym)
		elsif self.context.class == License

			response = []
			response += self.context.clinics 	if params.blank? || (params[:only] == Clinic.name.as_sym)
			response << self.context 					if params.blank? || (params[:only] == License.name.as_sym)
			response
		elsif self.context.class == ApiLicense

			auxiliar = self.context.licenses.includes(:clinics)
			response = []
			response += auxiliar											if params.blank? || (params[:only] == License.name.as_sym)
			if params.blank? || (params[:only] == Clinic.name.as_sym)
				auxiliar.each do |v|
					response += v.clinics.map{ |v| v }
				end
			end
			response << self.context 									if params.blank? || (params[:only] == ApiLicense.name.as_sym)
			response
		end
	end

	def abilities_by_permission_and_action(permission, action)
		if permission == Permission.profile && ([Action.assign,Action.unassign].include? action)
			sp = []
			assignable_profiles.each do |v|
				sp << Scope.new(name: v.name)
			end
			sp
		else
			scope_permissions.includes(:action,:permission,:scopes)
			.where(actions:{name: action.name},permissions:{name: permission.name})
		end
	end

  def self.find_for_authentication(warden_conditions)
    where(:email => warden_conditions[:email], :api_license_id => warden_conditions[:api_license_id]).first
  end

  def apply_profiles
  	it = UserProfile.where(user_id: self.id)
  	it.each do |v|
  		v.set_user_scope_permissions
  	end
  end

end