module Api
	module V1
		module Users

			class ScopePermissionsController <  Api::V1::ApiController

				before_filter :identify_user, :read_user

				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.where( id: params[:user_id] ).first
					render json: {:error => "404"}, :status => :render_not_found if @selected_user.nil?
					# TODO: ERROR 500
				end


				#List all the scope_permissions
				def index
					if true#authorize_request(:permission, :read, @selected_user)
						@permissions = @selected_user.scope_permissions.includes(:action,:permission,:scopes).all
						respond_to do | format |
							format.json { render json:  { scope_permissions: @permissions.as_json(:include=>{action:{only:[:id, :name]},
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
						@permission = @selected_user.scope_permissions.new(user_id: @selected_user.id, scope_permission_id: params[:permission_id])

						#:email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone
					 
						respond_to do |format|
							if @permission.save
								format.json { render json: @permission, status: :created}
							else
								format.json { render json: @permission.errors.to_json, status: :unprocessable_entity }
							end
						end
					end
				end

				# Updates an existing link between the selected_user and a scope_permission.
				# PRECONDITIONS: The given permission and the given user must exist in the system.
				def update
					@permission = @selected_user.scope_permissions.find(id: params[:id])
					
					if @permission.nil?
						format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }

					elsif authorize_request(:permission, :modify, @permission) #when false it renders not authorized
						respond_to do |format|
							if @permission.update_attributes(params[:permission].except(:permission_id))
								format.json { render json: @permission, status: :updated }
							else
								format.json { render json: @permission.errors, status: :unprocessable_entity }
							end
						end
					end
				end

				# Disposes an existing link between the selected_user and a scope_permission.
				# The user and the permission will remain in the system
				# PRECONDITIONS: The given permission and the given user must exist in the system.
	 
				def destroy
					@permission = @selected_user.scope_permissions.find(id: params[:id])
					
					if @permission.nil?
						format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }

					elsif authorize_request(:permission, :delete, @permission) #when false it renders not authorized
						respond_to do |format|
							if @permission.destroy
								format.json { render json: @permission, status: :updated }
							else
								format.json { render json: @permission.errors, status: :unprocessable_entity }
							end
						end
					end
				end      			

			end
		end
	end
end