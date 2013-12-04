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
				@users = User.where(api_license_id: @api_license.id)

				respond_to do |format|
					format.json { render json:  { users: @users.as_json }  }
				end
			end

			# GET /users/1
			# GET /users/1.json
			def show
				@user = User.includes(:profiles).find(params[:id])
				render json: @user.as_json(:include=>{profiles:{only:[:id, :name]} })
			end


			#POST /users/login
			def login
				#search the user by email
				user = User.find_by_email(params[:email])
				#check if the recieved password matches the user password
				if (user !=nil) && (user.valid_password?(params[:password]))
					#creates a session token
					session_token = user.new_session_token
					respond_to do |format|
						format.json { render json: {token: session_token, user_id: user.id}, status: :created}
					end
				else
					render json: {:error => "Wrong user or password"}, status: 401 #nuauthorized
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
				respond_to do |format|
					authorize_request(:user, :create)
					if ((!params[:user][:user_profiles].nil?) && Profile.where(id: params[:user][:user_profiles]).length != params[:user][:user_profiles].length)
						format.json { render json: { :error => "Could not find all the given profiles." }, status: :unprocessable_entity }
					else
						params[:user][:user_profiles] ||= []
						profiles_to_add=[]
						params[:user][:user_profiles].each_with_index do |s, i|
							authorize_request(:profile, :assign, {:scopes=>[Profile.find_by_id(s).name.parameterize.underscore.to_sym]} )
							profiles_to_add[i] = {profile_id: s}
						end 
						#creates the formatted_params for correct profile assignation
						formatted_params = params[:user].except(:user_profiles).except(:profiles)
						formatted_params[:api_license_id] = @api_license.id
						formatted_params[:user_profiles_attributes] = profiles_to_add

						@user = User.new(formatted_params)
						if @user.save
							format.json { render json: @user, status: :created}
						else
							format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
						end
					end
				end
			end


			# PUT /users/1
			# PUT /users/1.json
			def update
				respond_to do |format|
					if @selected_user.update_attributes(params[:user].except(:api_license_id))
						format.json { head :no_content }
					else
						format.json { render json: @selected_user.errors.full_messages, status: :unprocessable_entity }
					end
				end
			end

			# DELETE /users/1
			# DELETE /users/1.json
			def destroy
				@selected_user = User.find(params[:id])
				respond_to do |format|

					if @selected_user.destroy
						format.json { head :no_content }
					else
						format.json { render json: @selected_user.errors, status: :unprocessable_entity }
					end

				end
			end

			#users/:id/assign_profile?profile_id=9
			def assign_profile
				authorize_request(:profile, :assign)
				@profile = Profile.find(params[:profile_id])
				authorize_request(:profile, :assign, {:scopes=>[@profile]} )        
				@selected_user.profiles << @profile
				if @selected_user.save
					render json: @selected_user.as_json(:include => [:profiles]) , status: :created
				else
					render json: @selected_user.errors.to_json, status: :unprocessable_entity
				end
			end

			#users/:id/unassign_profile?profile_id=9
			def unassign_profile
				authorize_request(:profile, :unassign)
				@profile = @selected_user.user_profiles.find_by_profile_id(params[:profile_id])
				authorize_request(:profile, :unassign, {:scopes=>[@profile]} )

				if @profile.nil?
					render json: {:error => "404"}, status: 404 
				elsif @profile.delete
					head :no_content
				else
					render json: @profile.errors, status: :unprocessable_entity
				end
			end

			def assign_ability
			# users/:id/assign_ability?scope_permission_id=9
			# Creates a link between the selected_user and the scope_permission with id scope_permission_id given by the parameters.
			# PRECONDITIONS: The given scope_permission and the given user must exist in the system.      
				authorize_request(:permission, :create)
				formatted_params = {}
				formatted_params[:user_scope_permissions_attributes] = [{scope_permission_id: params[:scope_permission_id] }]
				if @selected_user.update_attributes(formatted_params)
					render json: @selected_user.as_json(:include=>:scope_permissions), status: :created
				else
					render json: @selected_user.errors.to_json, status: :unprocessable_entity
				end
			end


			def unassign_ability
			# Disposes an existing link between the user and a scope_permission.
			# The user and the permission will remain in the system
			# PRECONDITIONS: The given permission and the given user must exist in the system.
				authorize_request(:permission, :delete)
				
				respond_to do |format|
					@scope_permission = @selected_user.user_scope_permissions.find_by_scope_permission_id(params[:scope_permission_id])
					if @scope_permission.nil?
						format.json { render json: {:error => "404"}, status: 404 }            
					elsif @scope_permission.delete
						format.json { head :no_content }
					else
						format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
					end
				end
			end

			def assignable_profiles
			# List all the profiles that the selected_user user can assign to other users
			result = @selected_user.assignable_profiles_datatype
			render json:  { assignable_profiles: result }
			end

		end
	end
end
