module Api
	module V1
		module Users



			class PermissionsController <  Api::V1::ApiController

				before_filter :identify_user, :read_user

				# @selected_user will hold the user identified by the url parameters
				def read_user
					@selected_user = User.find( params[:user_id] )
					render json: {:error => "404"}, :status => :render_not_found if @selected_user.nil?
				end

				def index
					if true# authorize_request(:permission, :read, @selected_user)
						@permissions = @selected_user.scope_permissions.includes(:action,:permission).all
						respond_to do | format |
							format.json { render json:  { permissions: @permissions.as_json(:include=>[:action, :permission]) }  }
						end
	        		end
				end

      			def show
					if authorize_request(:permission, :read, @selected_user)
						@permission = @selected_user.permissions.find(params[:id])
						respond_to do |format|
							if @permission.nil?
              					format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }
            				else
	          					format.json { render json:  { users: @permission.as_json }  }
	          				end
	        			end
	        		end
      			end

				def create
		        if authorize_request(:permission, :create)
		          license = License.new(params[:license])
		          license.api_license_id = @api_license.id
		            #:email, :first_name, :last_name, :maximum_clinics, :maximum_users, :phone
		         
		          respond_to do |format|
		            if license.save
		              format.json { render json: license, status: :created}
		            else
		              format.json { render json: license.errors.to_json, status: :unprocessable_entity }
		            end
		          end
		        end

		      	def update
			   		@permission = @selected_user.permissions.where(id: params[:id]).first
			   		
			   		if @permission.nil?
				        format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }

			  		elsif authorize_request(:permission, :modify, @permission) #when false it renders not authorized
				   		respond_to do |format|
						if @permission.update_attributes(params[:permission].except(:permission_id))
							format.json { render json: @permission, status: :updated }
						else
							format.json { render json: permission.errors, status: :unprocessable_entity }
						end
					end
			    end

		      	def destroy
			   		@permission = @selected_user.permissions.where(id: params[:id]).first
			   		
			   		if @permission.nil?
				        format.json { render json: { :error => "Permission not found." }, status: :unprocessable_entity }

			  		elsif authorize_request(:permission, :delete, @permission) #when false it renders not authorized
				   		respond_to do |format|
						if @permission.destroy
							format.json { render json: @permission, status: :updated }
						else
							format.json { render json: permission.errors, status: :unprocessable_entity }
						end
					end
			    end      			

			end
		end
	end
end

