module Api
	module V1
		
		class ProfilesController < Api::V1::ApiController

			# GET /profiles
			def index				
			end

			# GET /profiles/1
			def show
			end

			# POST /profiles
			def create
				# { profile:
				# 	{ "name"=>string,
				# 		profile_abilities_attributes:
				# 			[ { scope_id:references, permission_id:references, action_id:references } ]
				# 	}
				# }
				@profile = Profile.new(params[:profile])
				@profile.api_license_id = @api_license.id
				if @profile.save
					render json: @profile, status: :created
				else
					render json: @profile.errors.full_messages, status: :unprocessable_entity
				end
			end

			#PUT /profiles/1
			def update
				# { profile:
				# 	{ "name"=>string,
				# 		profile_abilities_attributes:
				# 			[ { id:integer, scope_id:references, permission_id:references, action_id:references, _destroy:boolean } ]
				# 	}
				# }
				if @profile.update_attributes(params[:profile])
					head :no_content
				else
					render json: @profile.errors.full_messages, status: :unprocessable_entity
				end
			end


			# DELETE /profiles/1
			def destroy				
				if @profile.destroy
					head :no_content
				else
					render json: @profile.errors.full_messages, status: :unprocessable_entity
				end
			end

		end
	end
end