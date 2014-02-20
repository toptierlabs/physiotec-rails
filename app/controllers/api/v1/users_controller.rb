 module Api
	module V1
		class UsersController < Api::V1::ApiController

			# GET /users
			# GET /users.json
			def index				
			end

			# GET /users/1
			# GET /users/1.json
			def show		
			end


			#POST /users/login
			def login
				#search the user by email and api_license
				user = User.where(email: params[:email], api_license_id: @api_license.id).first
				#check if the recieved password matches the user password
				if (user.present?) && (user.valid_password?(params[:password]))
					#creates a session token
					session_token = user.new_session_token
					render json: {token: session_token, user_id: user.id, public_key: @api_license.public_api_key}, status: :created
				else
					render json: {:error => "Wrong user or password"}, status: 401 #unauthorized
				end
			end


			# POST /users
			#The content of the request must have a json with the following format:
			# { email: String,
			#   first_name: String,
			#   last_name: String,
			#   profile_ids: [integer],
			#   user_abilities_attributes:
			# 			[ { scope_id:references, permission_id:references, action_id:references } ]}
			def create
				#if user can create another user
				#new user from parameters

				validate_and_sanitize_context(params[:user])

				@user = User.new(params[:user])
				@user.api_license = @api_license

				if @user.save
					render json: @user, status: :created
				else
					render json: @user.errors.full_messages, status: :unprocessable_entity
				end

			end


			# PUT /users/1
			# PUT /users/1.json
			#The content of the request must have a json with the following format:
			# { id: references,
			#   email: String,
			#   first_name: String,
			#   last_name: String,
			#   profile_ids: [integer],
			#   user_abilities_attributes:
			# 			[ { id:references, scope_id:references, permission_id:references, action_id:references, _destroy:boolean } ]}
			def update
				validate_and_sanitize_context(params[:user])

				if @user.update_attributes(params[:user])
					head :no_content
				else
					render json: @user.errors.full_messages, status: :unprocessable_entity
				end
			end

			# DELETE /users/1
			# DELETE /users/1.json
			def destroy				
				if @current_user == @user
					render json: {error: " User cannot delete to himself" }, status: :unprocessable_entity
				elsif @user.destroy
					head :no_content
				else
					render json: @user.errors.full_messages, status: :unprocessable_entity
				end
			end

			def assignable_profiles
				# List all the profiles that the user user can assign to other users
				@assignable_profiles = @user.assignable_profiles
			end

		end
	end
end
