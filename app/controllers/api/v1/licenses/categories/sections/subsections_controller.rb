module Api
  module V1
    module Licenses
      module Categories
        module Sections
    
          class SubsectionsController < Api::V1::ApiController

            # GET licenses/:id/modules/:id/sections
            def index
              render json: { sections: @subsections.as_json(methods: :name, include: :exercise_media) }
            end

            # GET licenses/:id/modules/:id/sections/1
            def show
              render json: @subsection.as_json(methods: :name, include: :exercise_media)
            end

            # POST licenses/:id/modules/:id/sectionss
            def create
              # {
              #   subsection: {
              #     subsection_datum_id: references,
              #   }
              # }
              subsection = @section.subsections.new(params[:section])
              if subsection.save
                render json:   subsection, status: :created
              else
                render json:   subsection.errors.full_messages,
                       status: :unprocessable_entity
              end
            end

            # PUT licenses/:id/modules/:id/sections/1
            def update
              # {
              #   subsection: {
              #    id: integer,
              #    subsection_datum_id: references,
              #   }
              # }

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