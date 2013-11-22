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
					if authorize_request(:permission, :read)
						@scopes = @scope_group.scopes.all
						respond_to do | format |
							format.json { render json:  {scopes: @scopes.as_json }  }
						end
					end
				end

				# Shows the scope_permission for @selected_user
				def show
					if authorize_request(:permission, :read)
						@scopes = @scope_group.scopes.find(params[:id])
						respond_to do |format|
							format.json { render json:  { users: @scopes.as_json }  }
						end
					end
				end

				# Creates a new scope for the holded scope_group
				def create
					if authorize_request(:permission, :create)
						#:name, :scope_group
						@scope = Scope.new( name: params[:scope][:name])
						@scope_group.scopes << @scope
								 
						respond_to do |format|
							if @scope_group.save
								format.json { render json: @scope, status: :created}
							else
								format.json { render json: @scope.errors.to_json, status: :unprocessable_entity }
							end
						end
					end
				end

				# Updates an existing link between the selected_user and a scope_permission.
				def update
					@scope = @scope_group.scopes.find(params[:id])

					if authorize_request(:permission, :modify) #when false it renders not authorized
						respond_to do |format|
							if @scope.update_attributes(name: params[:scope][:name])
								format.json { render json: @scope, status: :updated }
							else
								format.json { render json: @scope.errors, status: :unprocessable_entity }
							end
						end
					end
				end

				# Disposes an existing scope.
				def destroy
					@scope = @scope_group.scopes.find(id: params[:id])
					
					if authorize_request(:permission, :delete) #when false it renders not authorized
						respond_to do |format|
							if @scope.destroy
								format.json { head :no_content }
							else
								format.json { render json: @scope.errors, status: :unprocessable_entity }
							end
						end
					end
				end      			

			end
		end
	end
end