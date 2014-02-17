module Api
  module V1
    module Licenses
      module Categories
    
        class SectionsController < Api::V1::ApiController


          # GET licenses/:id/modules/:id/sections
          def index
            render json: { sections: @sections.as_json(include: 
                                          { subsections: { only: [:id], methods: :name } }) }
          end

          # GET licenses/:id/modules/:id/sections/1
          def show
            render json: @section.as_json(include: { subsections:
                                                        { only: [:id], methods: :name } })
          end

          # POST licenses/:id/modules/:id/sectionss
          def create
            validate_and_sanitize_context(params[:section])
            section = @current_category.sections.new(params[:section])
            if section.save
              render json:   section, status: :created
            else
              render json:   section.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

          # PUT licenses/:id/modules/:id/sections/1
          def update            
            if @section.update_attributes(params[:section])
              head :no_content
            else
              render json:   @section.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

          # DELETE licenses/:id/modules/:id/sections/1
          def destroy
            if @section.destroy
              head :no_content
            else
              render json:   @section.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

        end

      end
    end
  end
end