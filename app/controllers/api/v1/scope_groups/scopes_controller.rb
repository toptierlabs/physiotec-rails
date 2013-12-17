module Api
	module V1
		module ScopeGroups

			class ScopesController <  Api::V1::ApiController

				before_filter :identify_user
				before_filter :read_scope_group

				# @scope_group will hold the scope_group identified by the url parameters
				def read_scope_group
					@scope_group = ScopeGroup.find( params[:scope_group_id] )
				end


				#List all the scopes
				def index
					authorize_request!(:scope, :read)
					@scopes = @scope_group.scopes.all
					render json:  { scopes: @scopes.as_json }
				end

				# Shows the scope_permission for @selected_user
				def show
					@scopes = @scope_group.scopes.find(params[:id])
					authorize_request!(:scope, :read, :model=>@scopes)
					render json:  { users: @scopes.as_json }
				end

				# Creates a new scope for the holded scope_group
				def create
					authorize_request!(:scope, :create)
					#:name, :scope_group
					@scope = Scope.new( name: params[:scope][:name])
					@scope_group.scopes << @scope
					if @scope_group.save
						render json: @scope, status: :created
					else
						render json: @scope.errors.errors.full_messages, status: :unprocessable_entity
					end
				end

				# Updates an existing link between the selected_user and a scope_permission.
				def update
					@scope = @scope_group.scopes.find(params[:id])
					 #when it fails renders not authorized
					authorize_request!(:scope, :modify, :model=>@scopes)
					if @scope.update_attributes(name: params[:scope][:name])
						head :no_content
					else
						render json: @scope.errors.full_messages, status: :unprocessable_entity
					end
				end

				# Disposes an existing scope.
				def destroy
					@scope = @scope_group.scopes.find(params[:id])
					authorize_request!(:scope, :delete, :model=>@scopes)
					if @scope.destroy
						head :no_content
					else
						render json: @scope.errors.full_messages, status: :unprocessable_entity
					end
				end      			

			end
		end
	end
end