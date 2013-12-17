module Api
	module V1
		
		class PermissionsController < Api::V1::ApiController
			before_filter :identify_user

			# GET /permissions
			# GET /permissions.json
			def index
				authorize_request!(:permission, :read)
				@permissions = Permission.where(:api_license_id => @api_license.id)
				render json: {permissions: @permissions.as_json(:include => :scope_groups)}
			end

			# GET /permissions/1
			# GET /permissions/1.json
			def show
				@permission = Permission.includes(:scope_groups).find(params[:id])
				authorize_request!(:permission, :read, :model=>@permission)
				render json: @permission.as_json(:include=>:scope_groups)
			end

			# POST /permissions
			# POST /permissions.json
			def create
				authorize_request!(:permission, :create)        
				#what happens if a scope_permission is created and then the permission's scopes are updated?

				#fix for api explorer compatibility
				params[:permission][:scope_groups].each{ |i| puts i}
				params[:permission][:scope_groups].map{ |i| i.to_s.to_i}
				if (ScopeGroup.where(id: params[:permission][:scope_groups]).length != params[:permission][:scope_groups].length)
					render json: { :error => "Could not find all the given scope groups." }, status: :unprocessable_entity

				else
					scopes_to_add=[]
					params[:permission][:scope_groups].each_with_index do |s, i|
						scopes_to_add[i] = {scope_group_id: s}
					end 

					#creates the formatted_params for correct creation of nested scopes
					formatted_params = params[:permission].except(:scope_groups)
					formatted_params[:permission_scope_groups_attributes] = scopes_to_add

					@permission = Permission.new(formatted_params)
					@permission.api_license_id = @api_license.id
					if @permission.save
						render json: @permission, status: :created
					else
						render json: @permission.errors.full_messages, status: :unprocessable_entity
					end
				end
			end

			# DELETE /permissions/1
			# DELETE /permissions/1.json
			def destroy        
				@permission = Permission.find(params[:id])
				authorize_request!(:permission, :delete, :model=>@permission)
				if @permission.destroy
					head :no_content
				else
					render json: @scope.errors.full_messages, status: :unprocessable_entity
				end
			end

		end
	end
end