module Api
  module V1
    module Licenses
      module Categories
        module Sections
    
          class SubsectionsController < Api::V1::ApiController

            # GET licenses/:id/modules/:id/sections
            def index
              subsections = @subsections
              render json: { sections: @subsections.as_json(methods: :name, include: :exercises) }
            end

            # GET licenses/:id/modules/:id/sections/1
            def show
              render json: @subsection.as_json(methods: :name, include: :exercises)
            end

            # POST licenses/:id/modules/:id/sectionss
            def create
              section = @section.subsections.new(params[:section])
              if section.save
                render json:   section, status: :created
              else
                render json:   section.errors.full_messages,
                       status: :unprocessable_entity
              end
            end

            # PUT licenses/:id/modules/:id/sections/1
            def update              
              if @subsection.update_attributes(params[:section])
                head :no_content
              else
                render json:   @subsection.errors.full_messages,
                       status: :unprocessable_entity
              end
            end

            # DELETE licenses/:id/modules/:id/sections/1
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
end