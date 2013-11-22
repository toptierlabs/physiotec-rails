module Api
  module V1
    
    class PermissionsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /permissions
      # GET /permissions.json
      def index
        if authorize_request(:permissions, :read) #give also api_license?
          @permissions = Permission.all #add context to permission, api_license or null (generic)
          respond_to do | format |
              format.json { render json: @permissions }
          end
        end
      end

      # GET /permissions/1
      # GET /permissions/1.json
      def show
        if authorize_request(:permission, :read)
          @permission = Permission.find(params[:id])
          respond_to do | format |
            format.json { render json: @permission }
          end
        end
      end

      # POST /permissions
      # POST /permissions.json
      def create
        #:name, :permission_scope_groups, :permission_scope_groups_attributes
        if authorize_request(:permission, :create)
          #permission.api_license_id = @api_license.id?          
          #what happens if a scope_permission is created and then the permission's scopes are updated?
          respond_to do |format|
            if (ScopeGroups.where(id: params[:permission][:scope_groups]).length != params[:permission][:scope_groups].length)
              format.json { render json: { :error => "Could not find all the given scope groups." }, status: :unprocessable_entity }

            else

              params[:permission][:scope_groups].each_with_index do |s, i|
                scopes_to_add[i] = {scope_group_id: s}
              end 

              #creates the formatted_params for correct creation of nested scopes
              formatted_params = params[:permission].except(:scope_groups)
              formatted_params[:permission_scope_groups] = scopes_to_add

              if @permission.create(formatted_params)
                format.json { render json: @permission, status: :created}
              else
                format.json { render json: @permission.errors, status: :unprocessable_entity }
              end

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