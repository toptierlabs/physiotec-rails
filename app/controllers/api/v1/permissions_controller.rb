module Api
	module V1
		
		class PermissionsController < Api::V1::ApiController

			# GET /permissions
			# GET /permissions.json
			def index
				authorize_request!(:permission, :read)
				@permissions = Permission.all
			end

			# GET /permissions/1
			# GET /permissions/1.json
			def show
				@permission = Permission.find(params[:id])
				authorize_request!(:permission, :read, :model=>@permission)
			end

		end
	end
end