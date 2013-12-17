module Api
	module V1
		
		class ProfilesController < Api::V1::ApiController
			before_filter :identify_user

			# GET /profiles
			def index
				authorize_request!(:profile, :read)
				@profiles = Profile.includes(:scope_permissions).where(api_license_id:@api_license.id) #add context to permission, api_license or null (generic)
				render json: { profiles: @profiles.as_json(:include=>:scope_permissions) }
			end

			# GET /profiles/1
			def show
				@profile = Profile.includes(:destination_profiles,:scope_permissions=>[:action,:permission,:scopes]).find(params[:id])
				authorize_request!(:profile, :read)
				render json: @profile.as_json(:include=>{:destination_profiles=>{},:scope_permissions=>{:include=>[:action,:permission,:scopes]}})
			end

			# POST /profiles
			def create
			# Creates a profile with the given params.
			# The params must be in the following format:
			#   { profile: { :scope_permissions=>[scope_permission_id],
			#								 :destination_profiles:=>[:profile_id]
			#                   :name => Sring} }

				authorize_request!(:profile, :create)
				if (ScopePermission.where(id: params[:profile][:scope_permissions]).length != params[:profile][:scope_permissions].length)
					render json: { :error => "Could not find all the given scope permissions." }, status: :unprocessable_entity
				 else
					scopes_to_add = []
					params[:profile][:scope_permissions].each do |s|
						scopes_to_add << {scope_permission_id: s}
					end

					profiles_to_add = []
					params[:profile][:destination_profiles].each do |v|
						profiles_to_add << {destination_profile_id: v}
					end 


					#creates the formatted_params for correct creation of nested scope permissions
					formatted_params = params[:profile].except(:scope_permissions,:destination_profiles)
					formatted_params[:profile_scope_permissions_attributes] = scopes_to_add
					formatted_params[:profile_assignment_attributes] = profiles_to_add
					formatted_params[:api_license_id] = @api_license.id

					@profile = Profile.new(formatted_params)
					@profile.api_license_id = @api_license.id
					if @profile.save
						render json: @profile, status: :created
					else
						render json: @profile.errors.full_messages, status: :unprocessable_entity
					end
				end
			end

			#PUT /profiles/1
			def update
			# Creates a profile with the given params.
			# The params must be in the following format:
			#   { profile: { :scope_permissions=>[scope_permission_id],
			#								 :destination_profiles:=>[:profile_id]
			#                   :name => Sring} }
				@profile = Profile.find(params[:id])
				#authorize_request!(:profile, :modify, @profile)

				current_profiles = []
				current_link = {}
				@profile.profile_assignment.each do | p |
					current_profiles << p.destination_profile_id
					current_link[p.destination_profile_id] = p.id
				end

				#get the profiles that must add
				add_profiles = params[:profile][:destination_profiles] - current_profiles

				#get the profiles that must delete
				remove_profiles = current_profiles - params[:profile][:destination_profiles]

				#profiles to remove
				profiles_remove = {}
				remove_profiles.each do | rp |
					profiles_remove[rp] = current_link[rp] 
				end
				#create pretty params
				update_profiles = {}
				i = 0
				profiles_remove.each do |k|
					#k holds an array with 2 elements, the first one is the scope_id, and the second one is the spgs_id
					update_profiles[i] = {destination_profile_id: k[0], _destroy: true, id: k[1]}
					i += 1
				end
				add_profiles.each do |s|
					update_profiles[i] = {destination_profile_id: s}
					i += 1
				end

				current_scope_permissions = []
				current_link_scope_permissions = {}
				@profile.profile_scope_permissions.each do | p |
					current_scope_permissions << p.scope_permission_id
					current_link_scope_permissions[p.scope_permission_id] = p.id
				end

				#get the scope_permissions that must add
				add_scope_permissions = params[:profile][:scope_permissions] - current_scope_permissions

				#get the scope_permissions that must delete
				remove_scope_permissions = current_scope_permissions - params[:profile][:scope_permissions]
				#scope_permissions to remove
				scope_permissions_remove = {}
				remove_scope_permissions.each do | rp |
					scope_permissions_remove[rp] = current_link_scope_permissions[rp] 
				end
				#create pretty params
				update_scope_permissions = {}
				i = 0
				scope_permissions_remove.each do |k|
				#k holds an array with 2 elements, the first one is the scope_id, and the second one is the spgs_id
					update_scope_permissions[i] = {scope_permission_id: k[0], _destroy: true, id: k[1]}
					i += 1
				end
				add_scope_permissions.each_with_index do |s|
					update_scope_permissions[i] = {scope_permission_id: s}
					i += 1
				end

				formatted_params = params[:profile].except(:scope_permissions,:destination_profiles)
				formatted_params[:profile_assignment_attributes] = update_profiles
				formatted_params[:profile_scope_permissions_attributes] = update_scope_permissions

				puts formatted_params.to_json
				puts current_profiles
				puts '*'*80

				if @profile.update_attributes(formatted_params)
					head :no_content
				else
					render json: @profile.errors.full_messages, status: :unprocessable_entity
				end
			end

			# DELETE /profiles/1
			def destroy
				@profile = Profile.find(params[:id])
				authorize_request!(:profile, :delete)
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
					render json: @profile.errors.errors.full_messages, status: :unprocessable_entity
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
					render json: @scope_permission.errors.full_messages, status: :unprocessable_entity
				end
			end

		end
	end
end