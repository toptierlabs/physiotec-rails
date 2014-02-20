module Api
  module V1
    module Licenses
    
      class CategoriesController < Api::V1::ApiController


        # GET /licenses/:id/sections
        def index
          render json: { modules: @categories.as_json(include: 
                                      { sections: { only: [:id], methods: :name } }) }
        end

        # GET /licenses/:id/modules/1
        def show
          render json: @current_category.as_json(include: { sections:
                                                    { :only=>[:id], methods: :name } })
        end

        # GET /licenses/:id/sections
        def create
          # { module:
          #   { *name_lc: string
          #     sections_attributes: [{sectium_data_id:references,
          #                                 subsection_datum_ids:[references]}]
          #   }
          # }
          # The name attribute is translatable.
          # So, It also gives you access to methods: name_fr, name_en, etc.
          @category = @current_license.categories.new(params[:module])
          @category.owner = @current_user

          if @category.save
            render json: @category, status: :created
          else
            render json:   @category.errors.full_messages,
                   status: :unprocessable_entity
          end
        end

        # PUT /module/1
        # PUT /module/1.json
        def update
          if @current_category.update_attributes(params[:module])
            head :no_content
          else
            render json:   @current_category.errors.full_messages,
                   status: :unprocessable_entity
          end
        end

        # DELETE /module/1
        # DELETE /module/1.json
        def destroy
          if @current_category.destroy
            head :no_content
          else
            render json:   @current_category.errors.full_messages,
                   status: :unprocessable_entity
          end
        end

      end
    end
  end
end