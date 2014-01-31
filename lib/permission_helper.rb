module PermissionHelper 

	# def can?(permission, action, extra_args = nil)
	# 	#sanitize the params
	# 	permission = permission.to_s.gsub("_", " ")
	# 	action = action.to_s.gsub("_", " ")
	# 	scopes = []
	# 	if extra_args.present? && extra_args[:scopes].present?
	# 		scopes = Scope.where(name: extra_args[:scopes])
	# 	end
	# 	model = extra_args[:model] if extra_args.present?
	# 	result = false

	# 	#preconditions
	# 	if model.present? &&
	# 		(model.api_license_id.present? && self.api_license_id.present?) &&
	# 		(model.api_license_id != self.api_license_id)
	# 		return false
	# 	end

	# 	sp = self.abilities_by_permission_and_action(permission, action)
	# 	if sp.present?
	# 		sp.each do |v|
	# 			result = scopes.blank? || v.check_scopes(scopes)

	# 			if result && model.blank?			
	# 				return "true1"

	# 			elsif result && model.present? && (v.permission.model_name == model.class.name)
	# 				clinic_scope = v.context_scope.name.as_sym
	# 				if model.respond_to?(:clinic_scopes)
	# 					return model.clinic_scopes(self).include? v.context_scope.name.as_sym
	# 				else
	# 					return "true2"
	# 				end
	# 			end
	# 			result = false
	# 		end
	# 	end
	# 	return "false3"

	# end

	def can?(permission, action, extra_args = nil)
		#sanitize the params
		extra_args = {} if extra_args.blank?
		permission = Permission.find_by_name(permission)
		action = Action.find_by_name(action)
		
		scopes = Scope.where(name: extra_args[:scopes])
		model = extra_args[:model]

		#preconditions
		if model.present? &&
			(model.respond_to?(:api_license_id) && self.respond_to?(:api_license_id)) &&
			(model.api_license_id.present? && self.api_license_id.present?) &&
			(model.api_license_id != self.api_license_id)
			return false
		end

		if model == self
			return true
		end

		abilities = self.abilities_by_permission_and_action(permission, action)

		check_scopes = scopes.present?
		check_model = model.present?
		
		result = false
		if abilities.present?
			abilities.each do |v| 
				if check_model && check_scopes
					result = v.check_scopes(scopes) && (model.clinic_scopes(self).include? v.context_scope.name.as_sym)

				elsif check_scopes					
					result = v.check_scopes(scopes)					

				elsif check_model					
					if model.respond_to?(:clinic_scopes)
						result = model.clinic_scopes(self).include? v.context_scope.name.as_sym
					else
						result = true
					end

				else
					result = true
				end
				puts result
				break if result
			end			
		end
		result
	end

end