ActiveAdmin.register Permission do
  filter :api_license
  filter :scope_groups
  filter :name
  filter :model_name
  filter :created_at
  filter :updated_at
    
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
      f.input :api_license
      f.input :name
      f.input :model_name
    end

    f.inputs "Permissions Scope Groups" do
      f.has_many :permission_scope_groups, :allow_destroy => true, :new_record => true do |cf|
        cf.input :scope_group
      end
    end

    f.actions
  end

end
