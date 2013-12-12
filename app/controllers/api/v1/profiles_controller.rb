module Api
	module V1
		
		class ProfilesController < Api::V1::ApiController
			before_filter :identify_user

			# GET /profiles
			def index
				authorize_request!(:profile, :read)
				@profiles = Profile.includes(:scope_permissions).find_by_api_license_id(@api_license.id) #add context to permission, api_license or null (generic)
				render json: @profiles.as_json(:include=>:scope_permissions)
			end

			# GET /profiles/1
			def show
				@profile = Profile.includes(:scope_permissions).find(params[:id])
				authorize_request!(:profile, :read, :model=>@profile)
				render json: @profile.as_json(:include=>:scope_permissions)
			end

			# POST /profiles
			def create
			# Creates a profile with the given params.
			# The params must be in the following format:
			#   { profile: { :scope_permissions=>[scope_permission_id],
			#                   :name => Sring} }

				authorize_request!(:profile, :create)
				if (ScopePermission.where(id: params[:profile][:scope_permissions]).length != params[:profile][:scope_permissions].length)
					render json: { :error => "Could not find all the given scope permissions." }, status: :unprocessable_entity
				 else
					scopes_to_add = []
					params[:profile][:scope_permissions].each do |s|
						scopes_to_add << {scope_permission_id: s}
					end 

					#creates the formatted_params for correct creation of nested scope permissions
					formatted_params = params[:profile].except(:scope_permissions)
					formatted_params[:profile_scope_permissions_attributes] = scopes_to_add
					formatted_params[:api_license_id] = @api_license.id

					@profile = Profile.new(formatted_params)
					@profile.api_license_id = @api_license.id
					if @profile.save
						render json: @profile, status: :created
					else
						render json: @profile.errors, status: :unprocessable_entity
					end
				end
			end

			# DELETE /profiles/1
			def destroy
				@profile = Profile.find(params[:id])
				authorize_request!(:profile, :delete, :model=>@profile)
				@profile.destroy
				head :no_content
			end

			# POST profiles/:id/assign_ability?scope_permission_id=9      
			def assign_ability
			# Creates a link between the profile and the scope_permission with id permission_id given by the parameters.
			# PRECONDITIONS: The given scope_permission and the given user must exist in the system.
				authorize_request!(:permission, :assign)
				@profile = Profile.find(params[:id])				
				formatted_params = {}
				formatted_params[:profile_scope_permissions_attributes] = [{scope_permission_id: params[:scope_permission_id] }]

				if @profile.update_attributes(formatted_params)
					render json: @profile.as_json(:include=>:scope_permissions), status: :created
				else
					render json: @profile.errors.to_json, status: :unprocessable_entity
				end
			end


			# POST profiles/:id/unassign_ability?scope_permission_id=9
			def unassign_ability
			# Disposes an existing link between the profile and a scope_permission.
			# The profile and the permission will remain in the system
			# PRECONDITIONS: The given permission and the given user must exist in the system.
				authorize_request!(:permission, :unassign)
				@profile = Profile.find(params[:id])			

				@scope_permission = @profile.profile_scope_permissions.find_by_scope_permission_id!(params[:scope_permission_id])        
				if @scope_permission.delete
					head :no_content
				else
					render json: @scope_permission.errors, status: :unprocessable_entity
				end
			end

		end
	end
end