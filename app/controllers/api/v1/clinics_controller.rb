module Api
  module V1
    
    class ClinicsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /clinics
      # GET /clinics.json
      def index
        authorize_request!(:clinic, :read)
        @clinics = Clinic.on_api_license(@api_license)
        render json: { clinics: @clinics.as_json }
      end

      # GET /clinics/1
      # GET /clinics/1.json
      def show
        @clinic = Clinic.find(params[:id])
        authorize_request!(:clinic, :read, :model=>@clinic)        
        render json: @clinic
      end

      # POST /clinics
      # POST /clinics.json
      def create
        authorize_request!(:clinic, :create)       
        @clinic = Clinic.new(params[:clinic])
        @clinic.api_license_id = @api_license.id
        if @clinic.save
          render json: @clinic, status: :created
        else
          render json: @clinic.errors.full_messages, status: :unprocessable_entity
        end
      end

      # PUT /clinics/1
      # PUT /clinics/1.json
      def update        
        clinic = Clinic.find(params[:id])
        authorize_request!(:clinic, :modify, :model=>clinic)
        if clinic.update_attributes(params[:clinic].except(:api_license_id))
          head :no_content
        else
          render json: clinic.errors.full_messages, status: :unprocessable_entity
        end
      end

      # DELETE /clinics/1
      # DELETE /clinics/1.json
      def destroy        
        @clinic = Clinic.find(params[:id])
        authorize_request!(:clinic, :delete, :model=>@clinic)
        @clinic.destroy
        head :no_content
      end

    end
  end
end