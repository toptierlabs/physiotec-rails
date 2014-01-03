module Api
	module V1
		class UsersController < Api::V1::ApiController
			# @current_user will hold the identified user
			before_filter :identify_user, :except=>[:login]

			before_filter :read_user, :except =>[:index, :login, :create]

			# @selected_user will hold the user identified by the url parameters
			def read_user
				@selected_user = User.find( params[:id] )
			end

			# GET /users
			# GET /users.json
			def index
				@users = User.on_api_license(@api_license)
				render json:  { users: @users.as_json }
			end

			# GET /users/1
			# GET /users/1.json
			def show
				@user = User.includes(:profiles).find(params[:id])
				authorize_request!(:user, :read, :model=>@user)
				render json: @user.as_json(:include=>{profiles:{only:[:id, :name], scope_permissions:{only:[:id, :name]} } })
			end


			#POST /users/login
			def login
				#search the user by email and api_license
				user = User.where(email: params[:email], api_license_id: @api_license.id).first
				#check if the recieved password matches the user password
				if (user.present?) && (user.valid_password?(params[:password]))
					#creates a session token
					session_token = user.new_session_token
					render json: {token: session_token, user_id: user.id}, status: :created
				else
					render json: {:error => "Wrong user or password"}, status: 401 #unauthorized
				end
			end


			# POST /users
			#The content of the request must have a json with the following format:
			# { email: String,
			#   first_name: String,
			#   last_name: String,
			#   profiles: [String] }
			def create
				#if user can create another user
				#new user from parameters
				authorize_request!(:user, :create)

				formatted_params = params[:user].except(:user_profiles, :profiles)
				formatted_params[:profile_ids] = params[:user][:user_profiles] || []
				@user = User.new(formatted_params)
				@user.api_license = @api_license
				@user.context = @api_license

				if @user.save
					render json: @user, status: :created
				else
					puts '*'*80
					puts 
					render json: @user.errors.full_messages, status: :unprocessable_entity
				end

			end


			# PUT /users/1
			# PUT /users/1.json
			def update
				#authorize_request!(:user, :modify, :model=>@selected_user)

				formatted_params = params[:user].except(:user_profiles, :profiles)
				formatted_params[:profile_ids] = params[:user][:user_profiles] || []

				authorize_request!(:permission, :assign) if params[:user][:scope_permission_ids].present?

				if @selected_user.update_attributes(formatted_params)
					head :no_content
				else
					render json: @selected_user.errors.full_messages, status: :unprocessable_entity
				end
			end

			# DELETE /users/1
			# DELETE /users/1.json
			def destroy
				authorize_request!(:user, :delete, :model=>@selected_user)
				if @current_user == @selected_user
					render json: {error: "User cannot delete to himself"}, status: :unprocessable_entity
				elsif @selected_user.destroy
					head :no_content
				else
					render json: @selected_user.errors.full_messages, status: :unprocessable_entity
				end
			end

			#users/:id/assign_profile?profile_id=9
			def assign_profile
				authorize_request!(:profile, :assign)
				@profile = Profile.find(params[:profile_id])
				authorize_request!(:profile, :assign, {:scopes=>[@profile]} )        
				@selected_user.profiles << @profile
				if @selected_user.save
					render json: @selected_user.as_json(:include => [:profiles]) , status: :created
				else
					render json: @selected_user.errors.full_messages, status: :unprocessable_entity
				end
			end

			#users/:id/unassign_profile?profile_id=9
			def unassign_profile
				authorize_request!(:profile, :unassign)
				@profile = @selected_user.user_profiles.find_by_profile_id(params[:profile_id])
				authorize_request!(:profile, :unassign, {:scopes=>[@profile]} )

				if @profile.nil?
					render json: {:error => "404"}, status: 404 
				elsif @profile.delete
					head :no_content
				else
					render json: @profile.errors.full_messages, status: :unprocessable_entity
				end
			end

			def assign_ability
			# users/:id/assign_ability?scope_permission_id=9
			# Creates a link between the selected_user and the scope_permission with id scope_permission_id given by the parameters.
			# PRECONDITIONS: The given scope_permission and the given user must exist in the system.      
				authorize_request!(:permission, :assign)
				formatted_params = {}
				formatted_params[:user_scope_permissions_attributes] = [{scope_permission_id: params[:scope_permission_id]}]
				if @selected_user.update_attributes(formatted_params)
					render json: @selected_user.as_json(:include=>:scope_permissions), status: :created
				else
					render json: @selected_user.errors.full_messages, status: :unprocessable_entity
				end
			end


			def unassign_ability
			# Disposes an existing link between the user and a scope_permission.
			# The user and the permission will remain in the system
			# PRECONDITIONS: The given permission and the given user must exist in the system.
				authorize_request!(:permission, :unassign)
		
				@scope_permission = @selected_user.user_scope_permissions.find_by_scope_permission_id(params[:scope_permission_id])
				if @scope_permission.nil?
					render json: {:error => "404"}, status: 404
				elsif @scope_permission.delete
					head :no_content
				else
					render json: @scope_permission.errors.full_messages, status: :unprocessable_entity
				end
			end

			def assignable_profiles
				# List all the profiles that the selected_user user can assign to other users
				result = @selected_user.assignable_profiles
				render json: { assignable_profiles: result }
			end

		end
	end
end
