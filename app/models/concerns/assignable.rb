module Assignable

  def minimum_scope_for(user)
    if !self.respond_to?(:context)
      return Scope.user_scope
    elsif self.respond_to?(:owner) && (self.owner == user)
      return Scope.user_scope
    else
      if self.context.class == Clinic
        if user.contexts.any? { |v| v == self.context }
          return Scope.clinic_scope
        end

        if user.contexts.any? { |v| matches(v, License, context.license_id) }
          return Scope.license_scope 
        end
        if user.contexts.any? { |v| matches(v, ApiLicense, context.api_license_id) }
          return Scope.clinic_scope 
        end 
      end
      if self.context.class == License

        if user.contexts.any? { |v| v == self.context }
          return Scope.license_scope

        elsif user.contexts.any? { |v| matches(v, ApiLicense, context.api_license_id) }
          return Scope.license_scope              
        end 
      end
      if self.context.class == ApiLicense
        if user.contexts.any? { |v| v == self.context }
          return Scope.api_scope              
        end
      end
    end
    return Scope.api_scope
  end

  private

    def matches(value, param_class, id)
      value.class == param_class && value.id == id
    end

end