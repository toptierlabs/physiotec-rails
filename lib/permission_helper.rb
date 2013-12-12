module PermissionHelper 
	attr_accessor :cache_user_permissions

	def can?(permission, action, extra_args = nil)
		#sanitize the params
		permission = permission.to_s.gsub("_", " ")
		action = action.to_s.gsub("_", " ")
		scopes = extra_args[:scopes] if extra_args.present?
		model = extra_args[:model] if extra_args.present?
		if scopes.nil?
			if model.nil?
				scope_permissions.get_by_permission_and_action(permission,action).present?
				return
			else
				false
				return
			end

		elsif scopes.present?
			scope_permission = nil
			result = false
			scope_permissions.get_by_permission_and_action(permission,action).each do |v|
				result = v.check_scopes(scopes)
			end
			if result && model.present?
				clinic_scope = scope_permission.context_scope.name.as_sym
				if (model.api_license_id == user.api_license_id)
					resullt = model.clinic_scopes.includes? scope_permission.context_scope.name.as_sym
				else
					result = false
				end		
			end
			result
			return
		end

	end

end