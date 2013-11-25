module Api
  module V1
    class ActionsController < Api::V1::ApiController      

      before_filter :identify_user

      #Displays all the actions available in the system
      def index
        if authorize_request(:permissions, :read)
          @actions = Action.all #add context to permission, api_license or null (generic)
          respond_to do | format |
              format.json { render json: @actions }
          end
        end
      end

      def show
        if authorize_request(:permission, :read)
          @action = Action.find(params[:id])
          respond_to do | format |
            format.json { render json: @action }
          end
        end
      end


    end
  end
end
