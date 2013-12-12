module Api
  module V1
    class ActionsController < Api::V1::ApiController      

      before_filter :identify_user

      #Returns all the actions available in the system
      def index
        authorize_request!(:permission, :read)
        @actions = Action.all
        render json: @actions
      end

      def show
        authorize_request!(:permission, :read)
        @action = Action.find(params[:id])
        render json: @action
      end

    end
  end
end
