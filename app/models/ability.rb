class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    #loads all permissions with them scopes for the ingresed user
    UserScopePermission.where(:user_id => user.id).each do |perm_scope|
      #converts the permission obtained from the database to a symbol (A => :a)
      permission = perm_scope.scope_permission.permission.name.parameterize.underscore.to_sym
      #converts the scope obtained from the database to a symbol (A => :a)
      scope = perm_scope.scope_permission.scope.name.parameterize.underscore.to_sym
      #creates the ability for the given user                                                                                                                   
      can permission, scope

      #If the user has the ability to manage users
      puts permission
      if permission == :user
        user.profiles.each do | profile |
          ProfileAssignment.where(:profile_id => profile.id).each do | assign_profile |
            #converts the name of the profile obtained from the database to a symbol (A b => :a_b)
            permission_sym = assign_profile.destination_profile.name.parameterize.underscore.to_sym
            #If can? :user, :create then can? :create, :'profile'
            can scope, permission_sym
          end
        end
      end


    end
  end   

end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
