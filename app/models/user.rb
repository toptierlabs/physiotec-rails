class User < ActiveRecord::Base

	include PermissionHelper

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
				 :recoverable, :trackable, :validatable, :confirmable#, :rememberable

	#Set the attributes validations
	validates :email, :first_name, :last_name, :api_license, :context,
						:presence => true

	validates :session_token, :uniqueness => true, :allow_blank => true

	validates :email, :email => true

	validates :context, :associated => { :message => "reached maximum clinics" },
											:if => lambda { (self.context_type == License.name) && self.license_id_changed? }

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
	has_many :profiles, :through => :user_profiles, before_add: :set_scope_permissions, before_remove: :remove_scope_permissions
	accepts_nested_attributes_for :user_profiles, :allow_destroy => true

	# Setup accessible (or protected) attributes
	attr_accessible :email, :password, :password_confirmation, :remember_me,
									:first_name, :last_name, :api_license_id, :session_token,
									:session_token_created_at, :profiles,
									:user_profiles_attributes, :user_scope_permissions_attributes,
									:context_id, :context_type, :profile_ids

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
		puts '/'*100
		puts ppl.to_json
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

	def abilities_by_permission_and_action(perm, act)
		permission = Permission.find_by_name(perm)
		action = Action.find_by_name(act)
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

	private

		#called when a profile is added to the user
		def set_scope_permissions(profile)
			p_sp = profile.scope_permission_ids
			u_sp = self.user_scope_permissions.where("scope_permission_id NOT IN (?)", p_sp).map{ |v| v.scope_permission_id}
			#scope_permisssions that it has to add
			add_scope_permission_ids = p_sp - u_sp
			self.scope_permissions << ScopePermission.where(id:add_scope_permission_ids)
		end

		#called when a profile is removed from the user
		def remove_scope_permissions(profile)
			p_sp = profile.scope_permission_ids
			#scope_permissions associated with the user except those linked with the deleted profile
			u_sp = self.profiles.where("scope_permission_id NOT IN (?)", p_sp).joins(:profile_scope_permissions)
						.select(:scope_permission_id).map{ |v| v.scope_permission_id}
			#scope_permisssions that it has to remove
			remove_scope_permission_ids = p_sp - u_sp
			self.scope_permissions.delete(ScopePermission.where(id:remove_scope_permission_ids))
		end

end