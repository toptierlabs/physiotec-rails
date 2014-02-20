module Api
  module V1
    
    class CategoriesController < Api::V1::ApiController

      # GET /modules
      # GET /modules.json
      def index
        render json: { modules: @categories.as_json(include: 
                                    { sections: { only: [:id, :name],
                                                  methods: :translations,
                                                  include: {
                                                    subsections: {methods: :translations}
                               } 
                        }}) }
      end

      # GET /modules/1
      # GET /modules/1.json
      def show
        render json: @category.as_json(include: { sections:
                                                  { :only=>[:id, :section_datum_id],
                                                    methods: [:translations, :name],
                                                    include: {subsections: {only: [:id, :subsection_datum_id],
                                                                            methods: [:name, :translations] } } } })
      end

      # POST /module
      # POST /module.json
      def create
          # { module:
          #   { *name_lc: string
          #     sections_attributes: [{sectium_data_id:references,
          #                                 subsection_datum_ids:[references]}]
          #   }
          # }
          # The name attribute is translatable.
        validate_and_sanitize_context(params[:module])
        category = Category.new(params[:module])
        category.owner = @current_user
        if category.save
          render json: category, status: :created
        else
          render json:   category.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # PUT /module/1
      # PUT /module/1.json
      def update
          # { module:
          #   {  id: integer
          #     *name_lc: string
          #     sections_attributes: [{id: integer, sectium_data_id:references,
          #                                 subsection_datum_ids:[references]}]
          #   }
          # }
          # The name attribute is translatable.
        validate_and_sanitize_context(params[:module])
        I18n.locale = params[:module][:translations_attributes].first[:locale]
        if @category.update_attributes(params[:module])
          head :no_content
        else
          render json:   @category.errors.full_messages,
                 status: :unprocessable_entity
        end
        I18n.locale = :en
      end

      # DELETE /module/1
      # DELETE /module/1.json
      def destroy
        if @category.destroy
          head :no_content
        else
          render json:   @category.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

    end
  end
end