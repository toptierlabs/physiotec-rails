module Api
  module V1
    module Licenses
    
      class ClinicsController < Api::V1::ApiController

        # GET /clinics
        # GET /clinics.json
        def index
          puts @clinics.as_json
          render json: { clinics: @clinics.as_json(:include=>{ :license=>{ :only=>:company_name } }) }
        end

        # GET /clinics/1
        # GET /clinics/1.json
        def show        
          render json: @clinic.as_json(:include=>{ :license=>{ :only=>:company_name } })
        end

        # POST /clinics
        # POST /clinics.json
        def create

          # { clinic: {"license_id"=>nil, "name"=>string } }
          clinic = @license.clinics.new(params[:clinic])
          clinic.api_license = @api_license
          if clinic.save
            render json: clinic, status: :created
          else
            render json: clinic.errors.full_messages, status: :unprocessable_entity
          end
        end

        # PUT /clinics/1
        # PUT /clinics/1.json
        def update
          # { clinic: {id: references, "license_id"=>nil, "name"=>string } }
          
          if @clinic.update_attributes(params[:clinic].except(:api_license_id))
            head :no_content
          else
            render json: clinic.errors.full_messages, status: :unprocessable_entity
          end
        end

        # DELETE /clinics/1
        # DELETE /clinics/1.json
        def destroy        
          if @clinic.destroy
            head :no_content
          else
            render json: @clinic.errors.full_messages, status: :unprocessable_entity
          end
        end

      end
    end
  end
end