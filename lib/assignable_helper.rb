module AssignableHelper

	#multiple associations with exercises
	#models:
	module ClassMethods
		def accessible_by(user, permission, action)
			scope_permission = user.scope_permission_for_read(permission)
			context = scope_permission.context_scope.name.as_sym
			where_condition = nil
			if (context == :own)
				where_condition = {owner_id: user.id}

			elsif (context == :clinic)				
				sql_where = "(context_type = ? and context_id = ?) or (owner_id = ?) or (context_type = ? and context_id = ?)"
				#get the clinics of the user
				users_clinic = user.context.users.map{ |v| v.id }
				where_condition = [sql_where, Clinic.name, user.context_id, users_clinic, ApiLicense.name, user.api_license_id]

			elsif (context == :license)
				sql_where = "(context_type = ? and context_id IN (?)) or (context_type = ? and context_id IN (?)) or owner_id IN (?) or (context_type = ? and context_id = ?)"
				clinics_id = []
				user_clinics = []
				if (user.context.respond_to?(:clinic))
					clinics = user.context.license.clinics
					user_context_id = 0
				else
					clinics = user.context.clinics
					if user.context.respond_to?(:license)
						user_context_id = user.context.id
					else #responds to api_license
						user_context_id = user.context.licenses.map { |v| v.id }
					end
				end
				
				clinics.each do |v|
					clinics_id << v.id
					v.users.each do |u|
					  user_clinics << u.id
					end
				end
				where_condition = [sql_where, License.name, user_context_id, Clinic.name, clinics_id, user_clinics, ApiLicense.name, user.api_license_id]

			else #api_license
				where_condition = { api_license_id: user.api_license_id }
			end

			self.where(where_condition)
		end
	end

	def self.included(base)		
		base.extend ClassMethods
		base.class_eval do
			has_many :permissible_scopes, as: :permissible
			has_many :scopes, :through=>:permissible_scopes

			# The owner must exists as a column in the model's table.
			# Instead of using has_one and an auxiliary table to specify the owner
			# we decided to use belongs_to for permformance optimization (less selects)
			belongs_to :owner, :class_name => "User"
			belongs_to :context, :polymorphic=>true

			attr_accessible :owner_id
			attr_accessible :context_id
		end		
	end



	def clinic_scopes(user)
		list_scopes = []
		#user is the owner
		if !self.respond_to?(:context)
			list_scopes <<  :own << :clinic << :license << :api_license
		elsif self.owner == user
			list_scopes <<  :own << :clinic << :license << :api_license
		#user belongs to the same clilic
		elsif (self.context.respond_to?(:clinic)) && ((user.clinics.include? self.context.clinic) || user.context = self.context)
			list_scopes << :clinic << :license << :api_license
		#user belongs to the same license
		elsif self.context.respond_to?(:license)
			if (user.context.respond_to?(:license)) && (self.context.license == user.context.license)
				list_scopes << :license << :api_license
			elsif (user.context.respond_to?(:api_license)) && (self.context.api_license == user.context.api_license)
				list_scopes << :api_license
			end
		#user belongs to the same api_license	
		elsif self.context.respond_to?(:api_license) && self.context.api_license == user.api_license
			list_scopes << :api_license
		end
		list_scopes
	end

end