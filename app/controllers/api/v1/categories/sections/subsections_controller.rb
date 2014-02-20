module Api
  module V1
    module Categories
      module Sections
    
        class SubsectionsController < Api::V1::ApiController

          # GET /modules/:id/sections/:id/subsections
          def index
            render json: { clinics: @subsections.as_json(include: 
                                          { exercises: { only: [:id, :name] } }) }
          end

          # GET /modules/:id/sections/:id/subsections/1
          def show
            render json: @subsection.as_json(include: { exercises:
                                                        { only: [:id, :name] } })
          end

          # POST /modules/:id/sections/:id/subsections
          def create
            # { subsection:
            #   {
            #     "subsection_datum_id",:references
            #   }
            # }
            subsection = Subection.new(params[:subsection])
            if subection.save
              subection json: subection, status: :created
            else
              render json:   subection.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

          # PUT /modules/:id/sections/:id/subsections/1
          # PUT /modules/:id/sections/:id/subsections/1.json
          def update
            # { subsection:
            #   {
            #     "id" : id
            #     "subsection_datum_id":references
            #   }
            # }
            if @subsection.update_attributes(params[:module])
              head :no_content
            else
              render json:   @subsection.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

          # DELETE /modules/:id/sections/:id/subsections/1
          # DELETE /modules/:id/sections/:id/subsections/1.json
          def destroy
            if @subsection.destroy
              head :no_content
            else
              render json:   @subsection.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

        end
        
      end
    end
  end
end