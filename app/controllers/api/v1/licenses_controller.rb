module Api
	module V1
		
		class LicensesController < Api::V1::ApiController
			before_filter :identify_user

			# GET /licenses
			# GET /licenses.json
			def index
				authorize_request!(:license, :read)
				@licenses = License.where(api_license_id: @api_license.id)
				render json: { licenses: @licenses.as_json }
			end

			# GET /licenses/1
			# GET /licenses/1.json
			def show
				authorize_request!(:license, :read)
				@license = License.find(params[:id])
				render json: @license
			end

			# POST /licenses
			# POST /licenses.json
			# Recieves #:email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone as params
			def create
				authorize_request!(:license, :create)
				license = License.new(params[:license])
				license.api_license_id = @api_license.id  
				if license.save
					render json: license, status: :created
				else
					render json: license.errors.to_json, status: :unprocessable_entity
				end        
			end

			# PUT /licenses/1
			# PUT /licenses/1.json
			def update				
				authorize_request!(:license, :modify)
				license = License.find(params[:id])
				if license.update_attributes(params[:license].except(:api_license_id))
					render json: license, status: :updated
				else
					render json: license.errors, status: :unprocessable_entity
				end
			end

			# DELETE /licenses/1
			# DELETE /licenses/1.json
			def destroy
				authorize_request!(:license, :delete)
				@license = License.find(params[:id])
				@license.destroy
				head :no_content
			end

		end
	end
end