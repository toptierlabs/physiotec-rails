module Api
  module V1
    
    class ScopeGroupsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /permissions
      # GET /permissions.json
      def index
        if authorize_request(:permission, :read) #give also api_license?
          @scope_groups = ScopeGroup.all(:include => :scopes) #add context to permission, api_license or null (generic)
          respond_to do | format |
              format.json { render json: {scope_groups: @scope_groups.as_json(:include => {:scopes=>{:only=>[:id,:name]}})} }
          end
        end
      end

      # GET /permissions/1
      # GET /permissions/1.json
      def show
        if authorize_request(:permission, :read)
          @scope_group = ScopeGroup.includes(:scopes).find(params[:id])
          respond_to do | format |
            format.json { render json: {scope_group: @scope_group.as_json(:include => {:scopes=>{:only=>[:id,:name]}})} }
          end
        end
      end

      # POST /permissions
      # POST /permissions.json
      def create
        #:name, :description, [ [:name] ]
        if authorize_request(:permission, :create)
          #permission.api_license_id = @api_license.id?          
          #what happens if a scope_permission is created and then the permission's scopes are updated?
          respond_to do |format|

            @permission.new( params[:permission].except(:scopes) )

            #creates the scopes
            params[:permission][:scopes].each do |scope_name|
              @permission.scopes = Scope.new(name: scope_name)
            end

            if @permission.save
              format.json { render json: @permission, status: :created}
            else
              format.json { render json: @permission.errors, status: :unprocessable_entity }
            end

          end
        end
      end

      #PUT /scope_groups/1
      #PUT /scope_groups/1.json
      # only updates the name and the description, for scope updating go to /scope_groups/scopes
      def update
        @permission = Permission.find(id: params[:id])
        if authorize_request(:permission, :modify)
          respond_to do |format|
            if @permission.update_attributes(params[:scope_group].only(:name, :description))
              format.json { render json: @permission, status: :updated }
            else
              format.json { render json: @permission.errors, status: :unprocessable_entity }
            end
          end
        end
      end

      # DELETE /permissions/1
      # DELETE /permissions/1.json
      def destroy
        if authorize_request(:permission, :delete)
          @permission = Permission.find(params[:id])
          @permission.destroy

          respond_to do |format|
            format.json { head :no_content }
          end
        end
      end

    end
  end
end