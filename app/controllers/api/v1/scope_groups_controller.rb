module Api
	module V1
		
		class ScopeGroupsController < Api::V1::ApiController
			before_filter :identify_user

			# GET /scope_groups
			# GET /scope_groups.json
			def index
				authorize_request!(:scopegroup, :read)
				@scope_groups = ScopeGroup.all(:include => :scopes)
				render json: {scope_groups: @scope_groups.as_json(:include => {:scopes=>{:only=>[:id,:name]}})}
			end

			# GET /scope_groups/1
			# GET /scope_groups/1.json
			def show
				@scope_group = ScopeGroup.includes(:scopes).find(params[:id])
				authorize_request!(:scopegroup, :read, :model=>@scope_group)
				render json: {scope_group: @scope_group.as_json(:include => {:scopes=>{:only=>[:id,:name]}})}
			end

			# POST /scope_groups
			#PARAMS: {  :scope_group=>{:name => String,
			#           :description => String,
			#           :scopes =>  [name:String] }}
			def create
				authorize_request!(:scopegroup, :create)
				@scope_group = ScopeGroup.new( params[:scope_group].except(:scopes) )
				@scope_group.api_license_id = @api_license.id
				#creates the scopes
				if !params[:scope_group][:scopes].nil?
					authorize_request!(:scope, :create)
					params[:scope_group][:scopes].each do |v|	
						@scope_group.scopes << Scope.new(name: v)
					end
				end

				if @scope_group.save
					render json: @scope_group, status: :created
				else
					render json: @scope_group.errors.full_messages, status: :unprocessable_entity
				end
			end

			#PUT /scope_groups/1
			#PUT /scope_groups/1.json
			# only updates the name and the description, for scope updating go to /scope_groups/scopes
			def update
				@scope_group = ScopeGroup.find(params[:id])
				authorize_request!(:scopegroup, :modify, :model=>@scope_group)
				if @scope_group.update_attributes(params[:scope_group].except(:api_license_id))
					head :no_content
				else
					render json: @scope_group.errors.full_messages, status: :unprocessable_entity
				end
			end

			# DELETE /scope_groups/1
			# DELETE /scope_groups/1.json
			def destroy
				@scope_group = ScopeGroup.find(params[:id])
				authorize_request!(:scopegroup, :delete, :model=>@scope_group)
				if @scope_group.destroy
					head :no_content
				else
					render json: @scope_group.errors.full_messages, status: :unprocessable_entity
				end
			end

		end
	end
end