module Api
  module V1
    module Licenses
      module Categories
    
        class SectionsController < Api::V1::ApiController
          before_filter :identify_user,
                        :identify_license,
                        :identify_category

          before_filter :identify_section, only: [:show, :update, :destroy]


          def identify_license
            @current_license = @api_license.licenses
                                           .find(params[:license_id])
            authorize_request! :license,
                               :read,
                               model: @current_license
          end

          def identify_category
            @current_category = @current_license.categories
                                                .find(params[:category_id])
            authorize_request! :module,
                               :read,
                               model: @current_category
          end

          def identify_section
            @current_section = @current_category.sections
                                                .find(params[:id])
          end



          # GET licenses/:id/modules/:id/sections
          def index
            sections = @current_category.sections
            render json: { sections: sections.as_json(include: 
                                          { subsections: { only: [:id], methods: :name } }) }
          end

          # GET licenses/:id/modules/:id/sections/1
          def show
            render json: @current_section.as_json(include: { subsections:
                                                        { only: [:id], methods: :name } })
          end

          # POST licenses/:id/modules/:id/sectionss
          def create
            authorize_request! :module,
                               :create
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
            authorize_request! :module,
                               :modify,
                               model: @current_category
            
            if @current_section.update_attributes(params[:section])
              head :no_content
            else
              render json:   @current_section.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

          # DELETE licenses/:id/modules/:id/sections/1
          def destroy        
            authorize_request! :module,
                               :delete,
                               model: @current_category

            if @current_section.destroy
              head :no_content
            else
              render json:   @current_section.errors.full_messages,
                     status: :unprocessable_entity
            end
          end

        end

      end
    end
  end
end