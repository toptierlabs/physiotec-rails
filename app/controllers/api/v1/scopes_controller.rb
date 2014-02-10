module Api
  module V1
    class ScopesController < Api::V1::ApiController      

      #Returns all the scopes available in the system
      def index
        authorize_request!(:permission, :read)
        @scopes = Scope.all
      end

      def show
        authorize_request!(:permission, :read)
        @scope = Scope.find(params[:id])
      end

    end
  end
end
