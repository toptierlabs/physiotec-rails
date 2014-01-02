module PermissionHelper 
	attr_accessor :cache_user_permissions

	def can?(permission, action, extra_args = nil)
		#sanitize the params
		permission = permission.to_s.gsub("_", " ")
		action = action.to_s.gsub("_", " ")
		scopes = []
		if extra_args.present? && extra_args[:scopes].present?
			scopes = Scope.where(name: extra_args[:scopes])
		end
		model = extra_args[:model] if extra_args.present?
		result = false

		#preconditions
		if model.present? &&
			(model.api_license_id.present? && self.api_license_id.present?) &&
			(model.api_license_id != self.api_license_id)
			return false
		end

		sp = self.abilities_by_permission_and_action(permission, action)
		if sp.present?
			sp.each do |v|
				result = scopes.blank? || v.check_scopes(scopes)

				if result && model.blank?			
					return "true1"

				elsif result && model.present? && (v.permission.model_name == model.class.name)
					clinic_scope = v.context_scope.name.as_sym
					if model.respond_to?(:clinic_scopes)
						return model.clinic_scopes(self).include? v.context_scope.name.as_sym
					else
						return "true2"
					end
				end
				result = false
			end
		end
		return "false3"

	end

end