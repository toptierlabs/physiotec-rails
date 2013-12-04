module Api
	module V1
		module Users

			class UserProfilesController <  Api::V1::ApiController


				before_filter :identify_user, :read_user


				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:id] )
				end

				# Returns all the profiles linked with the selected user
				def index
					authorize_request(:profile, :read)
					profiles = @selected_user.profiles
					render json: profiles
			 	end

				def show
					authorize_request(:profile, :read, @selected_user) #returns if request is not authorized
					@profile = @selected_user.profiles.find(params[:id])
					render json:  { users: @profile.as_json }
				end

			end 
		end
	end
end