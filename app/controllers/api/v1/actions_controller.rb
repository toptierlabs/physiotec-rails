module Api
  module V1
    class ActionsController < Api::V1::ApiController      

      #Returns all the actions available in the system
      def index
        authorize_request!(:permission, :read)
        @actions = Action.all
      end

      def show
        authorize_request!(:permission, :read)
        @action = Action.find(params[:id])
      end

    end
  end
end
