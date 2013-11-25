module Api
	module V1
		module Users

			class ScopePermissionsController <  Api::V1::ApiController

				before_filter :identify_user, :read_user

				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:id] )
				end


				#List all the scope_permissions
				def index
					if true#authorize_request(:permission, :read, @selected_user)
						@scope_permissions = @selected_user.scope_permissions.includes(:action,:permission,:scopes).all
						respond_to do | format |
							format.json { render json:  { scope_permissions: @scope_permissions.as_json(:include=>{action:{only:[:id, :name]},
													permission:{only:[:id, :name]}, scopes:{only: [:id, :name]}},
													#only render the previous fields
													:only => []) }  }
						end
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

				# Creates a link between the selected_user and the scope_permission with id permission_id given by the parameters.
				# PRECONDITIONS: The given scope_permission and the given user must exist in the system.
				def create
					if authorize_request(:permission, :create, @selected_user)
						@scope_permission = ScopePermission.find(params[:scope_permission][:scope_permission_id])
						@selected_user.scope_permissions << @scope_permission

						respond_to do |format|
							if @scope_permission.save
								format.json { render json: @scope_permission, status: :created}
							else
								format.json { render json: @scope_permission.errors.to_json, status: :unprocessable_entity }
							end
						end
					end
				end

				# Updates an existing link between the selected_user and a scope_permission.
				# PRECONDITIONS: The given permission and the given user must exist in the system.
				def update
					@scope_permission = @selected_user.scope_permissions.find(id: params[:id])
					
					if @scope_permission.nil?
						format.json { render json: { :error => "Scope Permission not found." }, status: :unprocessable_entity }

					elsif authorize_request(:permission, :modify, @scope_permission) #when false it renders not authorized
						respond_to do |format|
							if @scope_permission.update_attributes(params[:scope_permission][:scope_permission_id].except(:permission_id))
								format.json { render json: @scope_permission, status: :updated }
							else
								format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
							end
						end
					end
				end

				# Disposes an existing link between the selected_user and a scope_permission.
				# The user and the permission will remain in the system
				# PRECONDITIONS: The given permission and the given user must exist in the system.
	 
				def destroy
					@scope_permission = @selected_user.scope_permissions.find(id: params[:id])
					
					if @scope_permission.nil?
						format.json { render json: { :error => "Scope Permission not found." }, status: :unprocessable_entity }

					elsif authorize_request(:permission, :delete, @permission) #when false it renders not authorized
						respond_to do |format|
							if @scope_permission.destroy
								format.json { render json: @scope_permission, status: :updated }
							else
								format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
							end
						end
					end
				end      			

			end
		end
	end
end