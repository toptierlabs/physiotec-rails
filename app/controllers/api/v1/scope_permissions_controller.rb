module Api
	module V1

		class ScopePermissionsController <  Api::V1::ApiController

			before_filter :identify_user

			#List all the scope_permissions
			def index
				if true#authorize_request(:permission, :read)
					@scope_permissions = ScopePermission.includes(:action,:permission,:scopes).all
					respond_to do | format |
						format.json { render json:  { scope_permissions: @scope_permissions.as_json(:include=>{permission:{only:[:id, :name]},
							action:{only:[:id, :name]}, scopes:{only: [:id, :name]}},
							# only renders the previous fields and the object ids
							:only => [:id]) }  }
					end
				end
			end

			# Shows the permission for @selected_user
			# PRECONDITIONS: The given scope permission must exist in the system.
			def show
				if authorize_request(:permission, :read)
					@scope_permission = ScopePermission.includes(:action,:permission,:scopes).where(id: params[:id]).first
					respond_to do | format |
						if @scope_permission.nil?
							format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }
						else
							format.json { render json:  { scope_permission: @scope_permission.as_json(:include=>{permission:{only:[:id, :name]},
								action:{only:[:id, :name]}, scopes:{only: [:id, :name]}},
								# only renders the previous fields and the object id
								:only => [:id]) }  }
						end
					end
				end
			end

			# Creates a new scope_permission
			# PRECONDITIONS: The given action, permission and scopes must exist in the system.
			# PARAMS => {:action_id=>'', :permission_id=>'', scopes=>[:scope_id]}
			def create
				authorize_request(:permission, :create)
				respond_to do |format|
					#If action does not exists
					if Action.find_by_id(params[:scope_permission][:action_id]).nil?
						format.json { render json: { :error => "Could not find the given action." }, status: :unprocessable_entity }
					#If permission does not exists
					elsif Permission.find_by_id(params[:scope_permission][:permission_id]).nil?
						format.json { render json: { :error => "Could not find the given permission." }, status: :unprocessable_entity }
					else
						#validates the scopes
						perm = Permission.find_by_id(params[:scope_permission][:permission_id])
						if ( perm.scope_groups.joins(:scopes).where(scopes:{id: params[:scope_permission][:scopes]}).length != params[:scope_permission][:scopes].length )
							format.json { render json: { :error => "Could not find all the given scopes." }, status: :unprocessable_entity }
						else
							@scope_permission = ScopePermission.new(params[:scope_permission].except(:scopes))
							#creates the scope_permission_group_scopes
							params[:scope_permission][:scopes].each do | scope_id |
								scope = Scope.where(id: scope_id).first
								@scope_permission.scopes << scope
							end				
							if @scope_permission.save
								format.json { render json: @scope_permission, status: :created}
							else
								response_error = @scope_permission.errors
								format.json { render json: response_error, status: :unprocessable_entity }
							end
						end
					end
				end				
			end

			# Updates a permission, it updates the name, the action and the scopes
			# PRECONDITIONS: The given scope_permission must exist in the system.
			def update
				@scope_permission = ScopePermission.where(params[:id]).first
				respond_to do |format|	
					if @scope_permission.nil?
						format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }

					#The given scopes exists in the system
					elsif (params[:scope_permission][:scopes].length != Scope.where(:id => params[:scope_permission][:scopes]).length)
						format.json { render json: { :error => "Scopes not found." }, status: :unprocessable_entity }

					elsif authorize_request(:permission, :modify, @scope_permission) #when false it renders not authorized
											
						#Array with the id of scopes linked with @scope_permission
						current_scopes = []
						scope_permission_link = {}
						@scope_permission.scope_permission_group_scopes.includes(:scope).each do | spgs |
							current_scopes << spgs.scope_id
							scope_permission_link[spgs.scope_id] = spgs.id
						end

						#scopes to remove
						remove_scopes = current_scopes - params[:scope_permission][:scopes]

						#Scope_permission_group_scopes to remove
						scope_permission_remove = {}
						remove_scopes.each do | rs |
							scope_permission_remove[rs] = scope_permission_link[rs] 
						end

						#Scopes to add
						add_scopes = params[:scope_permission][:scopes] - current_scopes

						update_scopes = {}
						scope_permission_remove.each_with_index do |k, i|
						#k holds an array with 2 elements, the first one is the scope_id, and the second one is the spgs_id
							update_scopes[i] = {scope_id: k[0], _destroy: true, id: k[1]}
						end
						add_scopes.each_with_index do |s, i|
							update_scopes[i] = {scope_id: s}
						end	

						#{"0"=>{"scope_id"=>"", "_destroy"=>"0", "id"=>"66"}
						formatted_params = params[:scope_permission].except(:scopes)
						formatted_params[:scope_permission_group_scopes_attributes] = update_scopes

						if @scope_permission.update_attributes( formatted_params )
							format.json { render json: @scope_permission, status: :updated }
						else
							format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
						end
					end
				end
			end

			# Disposes the given scope_permission
			# The user and the permission will remain in the system
			# PRECONDITIONS: The given permission must exist in the system.

			def destroy					
				@scope_permission =ScopePermission.where(id: params[:id]).first
				respond_to do |format|
					if @scope_permission.nil?
						format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }
					elsif authorize_request(:permission, :delete, @scope_permission) #when false it renders not authorized
						if @scope_permission.destroy
							format.json { render status: :no_content }
						else
							format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
						end
					end
				end
			end


		end 
	end
end