class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    #loads all permissions with them scopes for the ingresed user
    UserScopePermission.where(:user_id => user.id).each do |perm_scope|
      #converts the permission obtained from the database to a symbol (A => :a)
      permission = perm_scope.scope_permission.permission.name.downcase.to_sym
      #converts the scope obtained from the database to a symbol (A => :a)
      scope = perm_scope.scope_permission.scope.name.downcase.to_sym
      #creates the ability for the given user                                                                                                                   
      can permission, scope
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
