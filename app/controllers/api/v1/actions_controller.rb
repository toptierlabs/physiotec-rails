module Api
  module V1
    class ActionsController < Api::V1::ApiController      

      #Returns all the actions available in the system
      def index
        
        @actions = Action.all
      end

      def show
        
        @action = Action.find(params[:id])
      end

    end
  end
end
