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
				if true#authorize_request(:permission, :read)
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
				if authorize_request(:permission, :create)
					@scope_permission = ScopePermission.new(params[:scope_permission].except(:scopes))
					#creates the scope_permission_group_scopes
					error = false
					params[:scope_permission][:scopes].each do | scope_id |
						scope = Scope.where(id: scope_id).first
						error = scope.nil?
						break if error
						@scope_permission.scopes << scope
					end

					respond_to do |format|
						if error
							format.json { render json: { :error => "Could not find the given scopes." }, status: :unprocessable_entity }
						elsif @scope_permission.save
							format.json { render json: @scope_permission, status: :created}
						else
							response_error = @scope_permission.errors || { :error => "Could not find the given scopes." }
							format.json { render json: response_error, status: :unprocessable_entity }
						end
					end
				end
			end

			# Updates an existing link between the selected_user and a permission.
			# PRECONDITIONS: The given permission and the given user must exist in the system.
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
						current_scopes = @scope_permission.scopes.map{ |s| s.id }
						#Scopes to remove
						remove_scopes = current_scopes - params[:scope_permission][:scopes]
						#Scopes to add
						add_scopes = params[:scope_permission][:scopes] - current_scopes

						@scope_permission.scope_permission_group_scopes.where(:scope_id => remove_scopes).each do |scope_id|
							#@scope_permission.permission_scope_groups_attributes=
						end

						add_scopes.each do | scope_id |
							scope = Scope.where(id: scope_id).first
							error = scope.nil?
							@scope_permission.scopes << scope
						end

						if @scope_permission.update_attributes(params[:scope_permission].except(:scopes) )
							format.json { render json: @scope_permission, status: :updated }
						else
							format.json { render json: @scope_permission.errors, status: :unprocessable_entity }
						end
					end
				end
			end

				# Disposes the given scope_permission
				# The user and the permission will remain in the system
				# PRECONDITIONS: The given permission exist in the system.

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