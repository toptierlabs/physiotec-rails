module Api
  module V1
    module Licenses
    
      class CategoriesController < Api::V1::ApiController
        before_filter :identify_user,
                      :identify_license
        before_filter :identify_category, only: [:show, :update, :destroy]

        def identify_license
          @current_license = @api_license.licenses.find(params[:license_id])
          authorize_request! :license,
                             :read,
                             model: @current_license
        end

        def identify_category
          @current_category = @current_license.categories
                                            .find(params[:id])
        end

        # GET /licenses/:id/sections
        def index
          authorize_request! :module,
                             :read

          categories = @current_license.categories
          render json: { modules: categories.as_json(include: 
                                      { sections: { only: [:id], methods: :name } }) }
        end

        # GET /licenses/:id/modules/1
        def show
          authorize_request! :module,
                              :read,
                              model: @current_category

          render json: @current_category.as_json(include: { sections:
                                                    { :only=>[:id], methods: :name } })
        end

        # GET /licenses/:id/sections
        def create
          puts params.to_json
          authorize_request! :module,
                             :create

          category = @current_license.categories.new(params[:module])
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
          authorize_request! :module,
                             :modify,
                             model: @current_category

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
          authorize_request! :module,
                             :delete,
                             model: @current_category

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