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
				@license = License.find(params[:id])
				authorize_request!(:license, :read, :model=>@license)				
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
				license = License.find(params[:id])
				authorize_request!(:license, :modify, :model=>license)
				if license.update_attributes(params[:license].except(:api_license_id))
					render json: license, status: :updated
				else
					render json: license.errors, status: :unprocessable_entity
				end
			end

			# DELETE /licenses/1
			# DELETE /licenses/1.json
			def destroy
				@license = License.find(params[:id])
				authorize_request!(:license, :delete, :model=>@license)
				if @license.destroy
					head :no_content
				else
					render json: @scope.errors, status: :unprocessable_entity
				end
			end

		end
	end
end