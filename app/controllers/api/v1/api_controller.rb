module Api
	module V1
		class ApiController < ApplicationController

			#require "permissions_helper"

			respond_to :json
			
			rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
			rescue_from ActionController::RoutingError, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
			rescue_from ActionController::UnknownController, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
			rescue_from AbstractController::ActionNotFound, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
			rescue_from PermissionsHelper::ForbiddenAccess, :with => :render_forbidden_access if AUTH_CONFIG['catch_exceptions']
			#rescue_from ActiveRecord::RecordInvalid, :with => :invalid_precondition if AUTH_CONFIG['catch_exceptions'] 
			#rescue_from Exception, :with => :render_error if AUTH_CONFIG['catch_exceptions']

			before_filter :cors_access_control, :except=>:cors_access_control
			before_filter :restrict_access, :except=>:cors_access_control
			before_filter :identify_user, :except=>[:login]

			def cors_access_control
				headers['Access-Control-Allow-Origin'] = '*'
				headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
				headers['Access-Control-Request-Method'] = '*'
				headers['Access-Control-Allow-Headers'] = 'X-URL-HASH, X-API-KEY, X-USER-ID, X-USER-TOKEN, Origin, X-Requested-With, Content-Type, Accept, Authorization'
				head(:ok) if request.request_method == "OPTIONS"
			end


	protected

				def authorize_request(permission, action, scopes=nil)
					if AUTH_CONFIG['super_user'] || @current_user.can?(permission, action, scopes)
						true
					else
						false
					end
				end

				def authorize_request!(permission, action, scopes=nil)
					if !authorize_request(permission, action, scopes)
						raise PermissionsHelper::ForbiddenAccess.new
					end
				end

				def validate_and_sanitize_context(options)
					case options[:context_type]
	        when "Own"
	          options[:context_type] = User.name
	          options[:context_id] = @current_user.id
	        when "ApiLicense"
	          options[:context_id] = @api_license.id
	        end

	        if options[:context_type].present?	  
	        	puts @current_user.to_yaml
	        	puts options[:context_type].as_sym  
		        contexts = @current_user.contexts(only: options[:context_type].as_sym) || []

		        authorized = contexts.select{ |v| v.id == options[:context_id] }.present?
		        raise PermissionsHelper::ForbiddenAccess.new unless authorized
		      end
				end

				def render_forbidden_access(exception)
					# logger.info(exception) # for logging 
					render json: {:error => "Not Authorized"}, status: 403
				end

				def render_not_found(exception)
					# logger.info(exception) # for logging 
					render json: { :error => exception.message }, status: 404 
				end

				def render_error(exception)
					# logger.info(exception) # for logging
					render json: {:error => "Internal server error"}, status: 500
				end

				def invalid_precondition(exception)
					# logger.info(exception) # for logging
					render json:  [exception.message] , status: 412
				end

				def check_api_token(secret_key, string_to_convert, hash)
					hash_verification = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, string_to_convert)).strip
					hash == hash_verification
				end

				def read_api_key
					api_key = request.headers["X-API-KEY"]
					api_key = params["api_key"] if api_key.nil?
					api_key
				end

				def read_user_id
					user_id = request.headers["X-USER-ID"]
					user_id = params["user_id"] if user_id.nil?
					user_id
				end

				def read_user_token
					user_token = request.headers["X-USER-TOKEN"]
					user_token = params["user_token"] if user_token.nil?
					user_token
				end

				def restrict_access
					api_key = read_api_key
					hash = request.headers["X-URL-HASH"] 
					unauthorized = false

					if api_key.present? && (hash.present? || AUTH_CONFIG['bypass_api_key_verification'])
						api_license = ApiLicense.find_by_public_api_key(api_key.strip)
						
						# Check if bypass api verification is enabled
						# check config/auth_config.yml and config/initializers/authentication.rb
						if !AUTH_CONFIG['bypass_api_key_verification']
							if api_license.present?
								matches = check_api_token(api_license.secret_api_key, request.original_url, hash)

								@api_license = api_license if matches
								unauthorized = !matches
							else
								unauthorized = true
							end
						else
							@api_license = api_license
						end
					else
						unauthorized = true
					end
					render json: {:error => "Not Authorized"}, :status => :unauthorized if unauthorized
				end

				def identify_user
					user_id = read_user_id
					user_token = read_user_token
					unauthorized = false

					if user_id.present? && (user_token.present? || AUTH_CONFIG['bypass_token_verification'])
						user = User.find(user_id)
						if !AUTH_CONFIG['bypass_token_verification']
							if user.session_token == user_token
								puts "ok 1"
								puts "*"*80
								@current_user = user
							else 
								unauthorized = true
							end
						else
							@current_user = user
						end
					else
						unauthorized = true
					end
					render json: {:error => "Not Authorized"}, :status => :unauthorized if unauthorized
				end

				

			end
	end
end