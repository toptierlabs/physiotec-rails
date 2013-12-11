module Api
  module V1
    class ActionsController < Api::V1::ApiController      

      before_filter :identify_user

      #Returns all the actions available in the system
      def index
        if authorize_request!(:permission, :read)
          @actions = Action.all #add context to permission, api_license or null (generic)
          render json: @actions
        end
      end

      def show
        if authorize_request!(:permission, :read)
          @action = Action.find(params[:id])
          render json: @action
        end
      end

    end
  end
end
