module Api
	module V1
		module Users

			class UserScopePermissionsController <  Api::V1::ApiController

				before_filter :identify_user, :read_user

				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:id] )
				end


				#List all the scope_permissions
				def index
					authorize_request(:permission, :read, @selected_user)
						@scope_permissions = @selected_user.scope_permissions.includes(:action,:permission,:scopes).all
						respond_to do | format |
							format.json { render json:  { scope_permissions: @scope_permissions.as_json(:include=>{action:{only:[:id, :name]},
													permission:{only:[:id, :name]}, scopes:{only: [:id, :name]}}) }  }
						end
				end

				# Shows the scope_permission for @selected_user
				# PRECONDITIONS: The given permission and the given user must exist in the system.
				def show
					if authorize_request(:permission, :read, @selected_user)
						@permission = @selected_user.scope_permissions.find(params[:id])
						respond_to do |format|
							if @permission.nil?
								format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }
							else
								format.json { render json:  { users: @permission.as_json }  }
							end
						end
					end
				end			

			end
		end
	end
end