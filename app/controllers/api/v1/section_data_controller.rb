module Api
  module V1
    
    class SectionDataController < Api::V1::ApiController

      # GET /sections
      def index
        # sections = SectionDatum.all
        # render json: { section_data: sections.as_json() }
      end

      # GET /sections/1
      def show
        section = SectionDatum.find(params[:id])
        render json: section.as_json(include:{ subsection_data:
                                                    { only: [:id],
                                                      methods: :translations } })
      end

      # POST /sections
      def create
        validate_and_sanitize_context(params[:section_datum])

        section = SectionDatum.new(params[:section_datum])
        section.api_license = @api_license
        if section.save
          render json: section, status: :created
        else
          render json:   section.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # PUT /sections/1
      # PUT /sections/1.json
      def update
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