ActiveAdmin.register Permission do
  #menu :parent => "2. Permissions", :label => "Permissions"
    
    #returns the scopes linked with the permission via the scope groups
    member_action :scopes, :method => :get do
      @response = []
      permission = Permission.find(params[:id])
      permission.permission_scope_groups.each do |permission_scope_groups|
      	permission_scope_groups.scope_group.scopes.each do |scope|
      		@response << scope.as_json(:only=>[:id, :name])
      	end
      end
      render json: @response
    end

  #customization on new and edit profile pages
  form do |f|
    f.inputs "Permission Attributes" do
      f.input :name      
    end

    f.inputs "Permissions Scope Groups" do
      f.has_many :permission_scope_groups, :allow_destroy => true, :new_record => true do |cf|
        cf.input :scope_group
      end
    end

    f.actions
  end

end
