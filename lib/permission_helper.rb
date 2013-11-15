module PermissionHelper 
  attr_accessor :cache_user_permissions

  def can?(permission, action, extra_args = {})
    #:permission, :action, {:scopes=>[], :subject=>nil}
   	#TODO get the scopes and the permissions for the current object, currently there is not a defined database model
    user_permissions ||= permission_scopes_list(permission, action)

    scopes = extra_args[:scopes] || []

    result = false
    user_permissions.each do |user_permission|
      #result is true iff the array of scopes and the array of user_permissions[:scopes]
      #are equal (both have the same length and the same elements, it ignores elements order)
      result = ((user_permission[:scopes].length == scopes.length) &&
        (user_permission[:scopes] - scopes).length == 0)
      break result
    end
    
    if result && !extra_args[:model].nil?
      #check if user permissions include model scopes for the user
      model_scopes = extra_args[:model].scopes(self) #[]
      user_permissions ##[[]]
      puts model_scopes
      user_permissions.each do | user_permission |
        puts user_permission
        #user_permission[:scopes] is included in model_scopes
        result = (user_permission[:scopes] - model_scopes).length == 0
        break result
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
     	self.scope_permissions.includes(:scope_permission_group_scopes).includes(:permission).each do | sp |
        aux = {}
       	if (permission.nil? || sp.permission.name.underscore.to_sym == permission) &&
          (action.nil? || sp.action.name.underscore.to_sym == action)
          #Inserts the permission and the action at the beginning
          aux[:permission] = sp.permission.name.parameterize.underscore.to_sym
          aux[:action] = sp.action.name.parameterize.underscore.to_sym
          #Inserts the scopes in the list
          aux[:scopes] = []
          #converts the name of the scope from This to :this
       		sp.scopes.each{ | s | aux[:scopes] << s.name.parameterize.underscore.to_sym }
          #save the elements
          result << aux
        end
      end
      @cache_user_permissions[permission][action] = result
    end

    result
  end

end