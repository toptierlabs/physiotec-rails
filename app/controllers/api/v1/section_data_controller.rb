module Api
  module V1
    
    class SectionDataController < Api::V1::ApiController

      before_filter :identify_user


      # GET /sections
      def index
        authorize_request! :section,
                           :read

        sections = SectionDatum.all
        render json: { section_data: sections.as_json(include: 
                                        { subsection_data: { only: [:id,
                                                                :name] } }) }
      end

      # GET /sections/1
      def show
        section = SectionDatum.find(params[:id])
        authorize_request! :section,
                           :read,
                           model: section

        render json: section.as_json(include:{ subsections:
                                                    { only: [:id, :name] } })
      end

      # POST /sections
      def create
        authorize_request! :section,
                           :create,
                           scopes: [params[:section_datum][:context_type]]

        section = SectionDatum.new(params[:section_datum])
        section.api_license = @api_license

        if section.save
          render json: section, status: :created
        else
          render json:   section.errors, #.full_messages,
                 status: :unprocessable_entity
        end
      end

      # PUT /sections/1
      # PUT /sections/1.json
      def update        
        section = SectionDatum.find(params[:id])
        authorize_request! :section,
                           :modify,
                           model: section

        if section.update_attributes(params[:section_datum])
          head   :no_content
        else
          render json:   section.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # DELETE /sections/1
      # DELETE /sections/1.json
      def destroy        
        section = SectionDatum.find(params[:id])
        authorize_request! :section,
                           :delete,
                           model: section

        if section.destroy
          head   :no_content
        else
          render json:   section.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

    end
  end
end