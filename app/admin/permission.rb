ActiveAdmin.register Permission do
    member_action :scopes, :method => :get do
      permission = Permission.find(params[:id])
      puts '#'*50
      @response = []
      permission.permission_scope_groups.each do |permission_scope_groups|
      	permission_scope_groups.scope_group.scopes.each do |scope|
      		@response << scope.as_json(:only=>[:id, :name])
      	end
      end
      puts @response.to_json
      render json: @response
    end
end
