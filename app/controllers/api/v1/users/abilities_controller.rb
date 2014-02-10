module Api
  module V1
    module Users

      class AbilitiesController <  Api::V1::ApiController

        before_filter :read_user

        #List all the scope_permissions
        def index
          authorize_request!(:user, :read, model: @selected_user)
          @abilities = @selected_user.user_abilities
        end

        # Shows the scope_permission for @selected_user
        # PRECONDITIONS: The given permission and the given user must exist in the system.
        def show
          authorize_request!(:user, :read, @selected_user)
          @ability = @selected_user.user_abilities.find(params[:id])
        end

        private

          # @selected_user will hold the user identified by the url parameters
          def read_user
            @selected_user = User.find( params[:user_id] )
          end

      end
    end
  end
end