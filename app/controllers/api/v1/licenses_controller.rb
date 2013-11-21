module Api
  module V1
    
    class LicensesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /licenses
      # GET /licenses.json
      def index
        if authorize_request(:license, :read)
          licenses = License.where(api_license_id: @api_license.id)
          respond_to do | format |
              format.json { render json: licenses }
          end
        end
      end

      # GET /licenses/1
      # GET /licenses/1.json
      def show
        if authorize_request(:license, :read)
          @license = License.find(params[:id])
          respond_to do | format |
            format.json { render json: @license }
          end
        end
      end

      # POST /licenses
      # POST /licenses.json
      def create
        if authorize_request(:license, :create)
          license = License.new(params[:license])
          license.api_license_id = @api_license.id
            #:email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone
         
          respond_to do |format|
            if license.save
              format.json { render json: license, status: :created}
            else
              format.json { render json: license.errors.to_json, status: :unprocessable_entity }
            end
          end
        end
        
      end

      # PUT /licenses/1
      # PUT /licenses/1.json
      def update
        
        if authorize_request(:license, :modify)
          license = License.where(id: params[:id]).first
          respond_to do |format|

            if license.nil?
              format.json { render json: { :error => "License not found." }, status: :unprocessable_entity }

            elsif license.update_attributes(params[:license].except(:api_license_id))
              format.json { render json: license, status: :updated }

            else
              format.json { render json: license.errors, status: :unprocessable_entity }
            end
          end
        end
      end

      # DELETE /licenses/1
      # DELETE /licenses/1.json
      def destroy
        if authorize_request(:license, :delete)
          @license = License.find(params[:id])
          @license.destroy

          respond_to do |format|
            format.json { head :no_content }
          end
        end
      end

    end
  end
end