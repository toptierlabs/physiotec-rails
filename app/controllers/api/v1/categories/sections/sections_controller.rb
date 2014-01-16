module Api
  module V1
    
    class SubsectionsController < Api::V1::ApiController
      before_filter :identify_user,
                    :identify_category,
                    :identify_section

      def identify_category
        @current_category = Category.find(params[:category_id])
        authorize_request! :module,
                           :read,
                           model: @current_category
      end

      def identify_section
        @current_section = Category.find(params[:section_id])
      end

      # GET /modules/:id/sections/:id/subsections
      def index
        subsections = @current_section.subsections
        render json: { clinics: subsections.as_json(include: 
                                      { exercises: { only: [:id, :name] } }) }
      end

      # GET /modules/:id/sections/:id/subsections/1
      def show
        subsection = Subection.find(params[:id])

        render json: subsection.as_json(include: { exercises:
                                                    { only: [:id, :name] } })
      end

      # POST /modules/:id/sections/:id/subsections
      def create
        authorize_request! :module,
                           :create
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
        subsection = Subsection.find(params[:id])
        authorize_request! :module,
                           :modify,
                           model: @current_category
        if subsection.update_attributes(params[:module])
          head :no_content
        else
          render json:   subsection.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # DELETE /modules/:id/sections/:id/subsections/1
      # DELETE /modules/:id/sections/:id/subsections/1.json
      def destroy        
        subsection = Subsection.find(params[:id])
        authorize_request! :module,
                           :delete,
                           model: @current_category
        if subsection.destroy
          head :no_content
        else
          render json:   subsection.errors.full_messages,
                 status: :unprocessable_entity
        end
      end


  end
end