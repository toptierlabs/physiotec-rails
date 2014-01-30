module Api
	module V1
		module Users

			class UserScopePermissionsController <  Api::V1::ApiController

				before_filter :identify_user, :read_user

				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:user_id] )
				end


				#List all the scope_permissions
				def index
					authorize_request!(:user, :read, model: @selected_user)
					scope_permissions = @selected_user.scope_permissions.includes(:action,:permission,:scopes).all

					formatted_response = {scope_permissions: scope_permissions.as_json(:include=>{action:{only:[:id, :name]},
																permission:{only:[:id, :name]}, scopes:{only: [:id, :name]}}),
																
																context: { 'Clinic'=> @selected_user.contexts(only: :clinic).as_json(only:[:id, :name],:methods => :entity),
																					 'License'=> @selected_user.contexts(only: :license).as_json(only:[:id, :company_name],:methods => :entity),
																					 'ApiLicense'=> @selected_user.contexts(only: :api_license).as_json(only:[:id, :name],:methods => :entity),
																					 'Own' => [{id: @selected_user.id, entity: User.name}] }}

					render json: formatted_response

				end

				# Shows the scope_permission for @selected_user
				# PRECONDITIONS: The given permission and the given user must exist in the system.
				def show
					authorize_request!(:user, :read, @selected_user)
					@permission = @selected_user.scope_permissions.find(params[:id])
					render json:  { users: @permission.as_json }
				end			

			end
		end
	end
end