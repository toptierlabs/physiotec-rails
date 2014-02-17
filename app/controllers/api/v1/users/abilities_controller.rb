module Api
  module V1
    module Users

      class AbilitiesController <  Api::V1::ApiController

        #List all the scope_permissions
        def index          
          #@abilities = @selected_user.user_abilities
        end

        # Shows the scope_permission for @selected_user
        # PRECONDITIONS: The given permission and the given user must exist in the system.
        def show          
          #@ability = @selected_user.user_abilities.find(params[:id])
        end

      end
    end
  end
end