module Api
	module V1
		
		class ProfilesController < Api::V1::ApiController

			# GET /profiles
			def index				
				render json: { profiles: @profiles.as_json }
			end

			# GET /profiles/1
			def show				
				render json: @profile.as_json
			end

			# POST /profiles
			def create
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