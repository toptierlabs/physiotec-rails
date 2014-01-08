module Api
	module V1

		class ScopePermissionsController <  Api::V1::ApiController

			before_filter :identify_user


			# List all the scope_permissions
			def index
				authorize_request!(:permission, :read)
					@scope_permissions = ScopePermission.joins(:action,:permission).all
					render json:  { scope_permissions: @scope_permissions.as_json(:include=>{action:{only:[:id, :name]},
										permission:{only:[:id, :name]}, scopes:{only: [:id, :name]}})
						}

			end


			# Shows the permission for @selected_user
			# PRECONDITIONS: The given scope permission must exist in the system.
			def show
				authorize_request!(:permission, :read)
				@scope_permission = ScopePermission.includes(:action,:permission,:scopes).find(params[:id])

				if @scope_permission.nil?
					render json: { :error => "Permission not found." }, status: :unprocessable_entity
				else
					render json:  { scope_permission: @scope_permission.as_json(:include=>{permission:{only:[:id, :name]},
						action:{only:[:id, :name]}, scopes:{only: [:id, :name]}},
						# only renders the previous fields and the object id
						:only => [:id]) }
				end				
			end

			# Creates a new scope_permission
			# PRECONDITIONS: The given action, permission and scopes must exist in the system.
			# PARAMS => {:action_id=>'', :permission_id=>'', scopes=>[:scope_id]}
			def create
				authorize_request!(:permission, :create)
				
				formatted_params = params[:scope_permission].except(:scopes)
				formatted_params[:scope_ids] = params[:scope_permission][:scopes] || []
				
				@scope_permission = ScopePermission.new(formatted_params)
				if @scope_permission.save
					render json: @scope_permission, status: :created
				else
					render json: @scope_permission.errors.full_messages, status: :unprocessable_entity
				end				
			end

			# Updates a permission, it updates the name, the action and the scopes
			# PRECONDITIONS: The given scope_permission must exist in the system.
			def update
				@scope_permission = ScopePermission.find(params[:id])
				authorize_request!(:permission, :modify, @scope_permission)

				formatted_params = params[:scope_permission].except(:scopes)
				formatted_params[:scope_ids] = params[:scope_permission][:scopes] || []

				if @scope_permission.update_attributes(formatted_params)
					head :no_content
				else
					render json: @scope_permission.errors.full_messages, status: :unprocessable_entity
				end

			end

			# Disposes the given scope_permission
			# The user and the permission will remain in the system
			# PRECONDITIONS: The given permission must exist in the system.

			def destroy
				@scope_permission =ScopePermission.find(params[:id])
				authorize_request!(:permission, :delete, @scope_permission)
				if @scope_permission.destroy
					head :no_content
				else
					render json: @scope_permission.errors.full_messages, status: :unprocessable_entity
				end
			end


		end 
	end
end