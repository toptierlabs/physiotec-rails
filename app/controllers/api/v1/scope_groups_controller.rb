module Api
  module V1
    
    class ScopeGroupsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /scope_groups
      # GET /scope_groups.json
      def index
        if authorize_request!(:permission, :read) #give also api_license?
          @scope_groups = ScopeGroup.all(:include => :scopes) #add context to permission, api_license or null (generic)
          respond_to do | format |
              format.json { render json: {scope_groups: @scope_groups.as_json(:include => {:scopes=>{:only=>[:id,:name]}})} }
          end
        end
      end

      # GET /scope_groups/1
      # GET /scope_groups/1.json
      def show
        if authorize_request!(:permission, :read)
          @scope_group = ScopeGroup.includes(:scopes).find(params[:id])
          respond_to do | format |
            format.json { render json: {scope_group: @scope_group.as_json(:include => {:scopes=>{:only=>[:id,:name]}})} }
          end
        end
      end

      # POST /scope_groups
      #PARAMS: {  :scope_group=>{:name => String,
      #           :description => String,
      #           :scopes =>  [name:String] }}
      def create
        #:name, :description, [ [:name] ]
        if authorize_request!(:permission, :create)
          #scope_groups.api_license_id = @api_license.id?          
          respond_to do |format|

            @scope_group = ScopeGroup.new( params[:scope_group].except(:scopes) )
            @scope_group.api_license_id = @api_license.id

            #creates the scopes
            if !params[:scope_group][:scopes].nil?
              params[:scope_group][:scopes].each do |scope_name|
                @scope_group.scopes << Scope.new(name: scope_name)
              end
            end

            if @scope_group.save
              format.json { render json: @scope_group, status: :created}
            else
              format.json { render json: @scope_group.errors, status: :unprocessable_entity }
            end

          end
        end
      end

      #PUT /scope_groups/1
      #PUT /scope_groups/1.json
      # only updates the name and the description, for scope updating go to /scope_groups/scopes
      def update
        @scope_group = ScopeGroup.find(params[:id])
        #authorize_request!(:permission, :modify)
        if @scope_group.update_attributes(params[:scope_group].except(:api_license_id))
          head :no_content
        else
          render json: @scope_group.errors.full_messages, status: :unprocessable_entity
        end
      end

      # DELETE /scope_groups/1
      # DELETE /scope_groups/1.json
      def destroy
        if authorize_request!(:permission, :delete)
          @scope_group = ScopeGroup.find(params[:id])
          @scope_group.destroy

          respond_to do |format|
            format.json { head :no_content }
          end
        end
      end

    end
  end
end