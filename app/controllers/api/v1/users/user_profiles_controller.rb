module Api
	module V1
		module Users

			class UserProfilesController <  Api::V1::ApiController

				# Returns all the profiles linked with the selected user
				def index
			 	end

				def show
					render json:  { users: @profile.as_json }
				end

			end 
		end
	end
end