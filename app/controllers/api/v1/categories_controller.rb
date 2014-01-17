module Api
  module V1
    
    class CategoriesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /modules
      # GET /modules.json
      def index
        authorize_request! :module,
                           :read

        categories = @api_license.categories
        render json: { modules: categories.as_json(include: 
                                    { sections: { only: [:id, :cname] } }) }
      end

      # GET /modules/1
      # GET /modules/1.json
      def show
        category = Category.find(params[:id])
        authorize_request! :module,
                           :read,
                           model: category

        render json: category.as_json(include: { sections:
                                                  { :only=>[:id], methods: :name } })
      end

      # POST /module
      # POST /module.json
      def create
        authorize_request! :module,
                           :create

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
        category = Category.find(params[:id])
        authorize_request! :module,
                           :modify,
                           model: category

        if category.update_attributes(params[:module])
          head :no_content
        else
          render json:   category.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      # DELETE /module/1
      # DELETE /module/1.json
      def destroy        
        category = Category.find(params[:id])
        authorize_request! :module,
                           :delete,
                           model: category

        if category.destroy
          head :no_content
        else
          render json:   category.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

    end
  end
end