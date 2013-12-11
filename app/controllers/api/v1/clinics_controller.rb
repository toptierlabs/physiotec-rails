module Api
  module V1
    
    class ClinicsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /permissions
      # GET /permissions.json
      def index
        authorize_request!(:clinic, :read)
        @clinics = Clinic.where(:api_license_id => @api_license.id)
        render json: { clinics: @clinics.as_json }
      end

      # GET /permissions/1
      # GET /permissions/1.json
      def show
        authorize_request!(:clinic, :read)
        @clinic = Clinic.find(params[:id])
        render json: @clinic
      end

      # POST /permissions
      # POST /permissions.json
      def create
        authorize_request!(:clinic, :create)        
        @clinic = Clinic.new(params[:clinic])
        @clinic.api_license_id = @api_license.id
        if @clinic.save
          render json: @clinic, status: :created
        else
          render json: @clinic.errors, status: :unprocessable_entity
        end
      end

      # DELETE /permissions/1
      # DELETE /permissions/1.json
      def destroy        
        @clinic = Permission.find(params[:id])
        authorize_request!(:clinic, :delete, :model=>@clinic)
        @clinic.destroy
        head :no_content
      end

    end
  end
end