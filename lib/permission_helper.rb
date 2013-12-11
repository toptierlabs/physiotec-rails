module PermissionHelper 
	attr_accessor :cache_user_permissions

	def permission_and_action(permission, action)
		scope_permissions.includes(:action,:permission)
		.where(actions:{name: action},permissions:{name: permission}).present?
	end

	def can?(permission, action, extra_args = nil)
		#:permission, :action, {:scopes=>[], :model=>nil}

		result = false

		scopes = []
		if ( (extra_args.present?) && (extra_args[:scopes].present?) ) 
			scopes = extra_args[:scopes]
		end

		scope_permission = nil
		scope_permissions.includes(:action,:permission,:scopes)
		.where(actions:{name: action},permissions:{name: permission}).each do |v|
			# result is true iff the array of scopes from the params is included 
			# in the array of scopes from the user, ingnoring the scopes belonging
			# to the clinic scope group
			if ((v.permission.name_as_sym == permission) && (v.action.name_as_sym == action)) &&
				(extra_args[:model].nil? || (v.permission.model_name == extra_args[:model].class_name))
				if extra_args.present? && extra_args[:model].present?
					scope_list = v.scopes.where(['scope_group_id != ?', ScopeGroup.group_clinic_id])
					.map{ |s| s.name_as_sym }
				else
					scope_list = v.scopes.map{ |s| s.name_as_sym }
				end
				if ((scope_list.length == scopes.length) && (scope_list - scopes).length == 0)
					scope_permission = v
					result = true
				end
				break if result
			end
			break if result
		end

		if result && extra_args.present? && extra_args[:model].present?
			#check the context
			model = extra_args[:model]
			clinic_scope = scope_permission.context_as_sym
			if (model.api_license_id == user.api_license_id)
				if (model.owner == self)
					result = true
				elsif (model.clinic_scopes(self).include? clinic_scope)
					#check the scopes
					result = model.check_scopes(scope_permission.scopes)
				else
					result = false
				end
			else
				result = false
			end			
				
		end
		result
	end


end