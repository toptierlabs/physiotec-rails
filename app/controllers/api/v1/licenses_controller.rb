module Api
  module V1
    class LicensesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /licenses
      # GET /licenses.json
      def index
        error = !validates(@current_user, :license, :read)
        licenses = License.where(api_license_id: @api_license.id) unless error 
        respond_to do |format|
          if !error
            format.json { render json: licenses }
          else
            error = { :error => "Can not complete the operation because you do not have sufficient privileges." }
            format.json { render json: error, status: :unprocessable_entity }
          end

        end
      end

      # GET /licenses/1
      # GET /licenses/1.json
      def show
        @license = License.find(params[:id])

        respond_to do |format|
          format.json { render json: @license }
        end
      end


      # POST /licenses
      # POST /licenses.json
      def create
        error = !validates(@current_user, :license, :create)
        if !error
          license = License.new(params[:license].except(:api_license_id))
          license.api_license_id = @api_license.id
          #:email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone
          error = !license.save
        end

        respond_to do |format|
          if !error
            format.json { render json: license, status: :created}
          else
            response_error = { :error => "Can not complete the operation because you do not have sufficient privileges." }
            response_error = license.errors unless license.nil?
            format.json { render json: response_error, status: :unprocessable_entity }
          end
        end
      end

      # PUT /licenses/1
      # PUT /licenses/1.json
      def update
        error = !validates(@current_user, :license, :create)
        license = License.where(id: params[:id]).first unless error
        error = true if license.nil?
        if !error
          puts params[:license].to_json
          error = !license.update_attributes(params[:license].except(:api_license_id))
          puts error 

          respond_to do |format|
            if !error
              format.json { render json: license, status: :updated }
            else
              response_error = { :error => "Can not complete the operation." }
              response_error = lincense.errors unless license.nil?
              format.json { render json: response_error, status: :unprocessable_entity }
            end
          end
        end
      end

      # DELETE /licenses/1
      # DELETE /licenses/1.json
      def destroy
        @license = License.find(params[:id])
        @license.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end
    end
  end
end
