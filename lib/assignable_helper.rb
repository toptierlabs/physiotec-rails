module AssignableHelper

	#multiple associations with exercises
	#models:
	module ClassMethods
		def accessible_by(user, permission, action)
			scope_permission = user.scope_permission_for_read(permission, action)
			context = scope_permission.scopes.find_by_scope_group_id(ScopeGroup.group_clinic_id).name_as_sym
			where_condition = nil
			puts context
			puts '-'*80
			if (context == :own)
				where_condition = {owner_id: user.id}

			elsif (context == :clinic)
				#get the clinics of the user
				sql_where = "(context_type = ? and context_id = ?) or (owner_id = ?)"
				where_condition = [sql_where, Clinic.name, user.context_id, user.id]

			elsif (context == :license)
				sql_where = "(context_type = ? and context_id = ?) or (context_type = ? and context_id IN (?))"
				clinics = []
				if (user.context.respond_to?(:clinic))
					clinics = user.context.license.clinics.map{ |v| v.id }
				else #responds to :license
					clinics = user.context.clinics.map{ |v| v.id }
				end
				where_condition = [sql_where, License.name, user.context_id, Clinic.name, clinics]

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


	def check_scopes(scopes)
		result = self.scopes.blank?
		puts self.scopes.nil?
		self.scopes.each do | v |			
			result = v.can_manipulate?(scopes)
			break if result
		end
		result
	end

	def clinic_scopes(user)
		list_scopes = []
		#user is owner
		if self.owner == user
			list_scopes <<  :own << :clinic << :license << :api_license
		#user belongs to the same clilic
		elsif (self.context.respond_to?(:clinic)) && (user.clinics.include? self.context.clinic)
			list_scopes << :clinic << :license << :api_license
		#user belongs to the same license
		elsif self.context.respond_to?(:license) && self.context.license == user.license
			list_scopes << :license << :api_license
		#user belongs to the same api_license	
		elsif self.context.respond_to?(:api_license) && self.context.api_license == user.api_license
			list_scopes << :api_license
		end
		list_scopes
	end





		#select scopes and scope groups associated with this model
		# self_scope_groups = self.scopes.map{ |v| v.scope_group_id }.uniq!
		# puts self_scope_groups
		# #create array with the scope groups of the given parameters
		# param_scope_groups = Scope.includes(:scope_groups).where(scope_id: scopes).map{ |v| v.scope_group_id }.uniq!#???
		# if ( (self_scope_groups - param_scope_groups).length != 0 )
		# 	return false
		# #check context


		#!!!!!!////----//// remove clinic scope group from the created array
		#!!!!!!////----//// check the Clinic scope of the permission and the context of the object match

		#check if the arrays are equal
		#compare arrays and if they match

end