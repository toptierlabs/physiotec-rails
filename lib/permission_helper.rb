module PermissionHelper 
  attr_accessor :cache_user_permissions

  def can?(api_license, permission, action, extra_args = nil)
    #:permission, :action, {:scopes=>[], :subject=>nil}
   	#TODO get the scopes and the permissions for the current object, currently there is not a defined database model

    result = false
    if !self.api_license.nil? && (self.api_license_id == api_license.id)
      user_permissions ||= permission_scopes_list(permission, action)

      #if extra_args[:scopes] equals nils then scopes := [], else extra_args[:scopes]
      scopes = ((not extra_args.nil?) && (not extra_args[:scopes].nil?)) ? extra_args[:scopes] : []

      
      user_permissions.each do |user_permission|
        #result is true iff the array of scopes and the array of user_permissions[:scopes]
        #are equal (both have the same length and the same elements, it ignores elements order)
        result = ((user_permission[:scopes].length == scopes.length) &&
          (user_permission[:scopes] - scopes).length == 0)
        break if result
      end
      
      if result && !extra_args.nil? && !extra_args[:model].nil?
        #check if user permissions include model scopes for the user
        model_scopes = extra_args[:model].scopes(self) #[]
        user_permissions ##[[]]
        puts model_scopes
        user_permissions.each do | user_permission |
          #user_permission[:scopes] is included in model_scopes
          result = (user_permission[:scopes] - model_scopes).length == 0
          break result
        end
      end
    end
    result
  end


  #This method returns a list of lists with the scope names
  #for the given permissions and actions
  def permission_scopes_list(permission = nil, action = nil)

    @cache_user_permissions ||= {}
    @cache_user_permissions[permission] ||= {}

    if  !@cache_user_permissions[permission][action].nil?
      result = @cache_user_permissions[permission][action]

    else
      result = []
     	self.scope_permissions_list.each do | sp |
        aux = {}        
       	if (permission.nil? || sp[:permission] == permission) &&
          (action.nil? || sp[:action] == action)

          #Inserts the scope_permission element to the result list
          result << sp
        end
      end
      @cache_user_permissions[permission][action] = result
    end

    result
  end

end