module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json
      rescue_from Exception, :with => :render_error if AUTH_CONFIG['catch_exceptions']
      rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
      rescue_from ActionController::RoutingError, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
      rescue_from ActionController::UnknownController, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']
      rescue_from AbstractController::ActionNotFound, :with => :render_not_found if AUTH_CONFIG['catch_exceptions']


      before_filter :restrict_access, :except=>:cors_access_control
      after_filter :cors_access_control, :except=>:cors_access_control

      def cors_access_control
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'X-API-KEY, X-USER-ID, X-USER-TOKEN, Origin, X-Requested-With, Content-Type, Accept, Authorization'
        head(:ok) if request.request_method == "OPTIONS"
      end


  protected
        def authorize_request(permission, action, scopes=nil)
          auth = @current_user.can?(permission, action, scopes)
          render json: {:error => "401"}, :status => :unauthorized if !auth
          auth
        end

        def render_not_found(exception)
          # logger.info(exception) # for logging 
          respond_to do |format|
            render json: {:error => "404"}, status: 404
          end    
        end

        def render_error(exception)
          # logger.info(exception) # for logging
          respond_to do |format|
            render json: {:error => "500"}, status: 500
          end
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

          if !api_key.nil? && (!hash.nil? || AUTH_CONFIG['bypass_api_key_verification'])
            api_license = ApiLicense.find_by_public_api_key(api_key)
            
            # Check if bypass api verification is enabled
            # check config/auth_config.yml and config/initializers/authentication.rb
            if !AUTH_CONFIG['bypass_api_key_verification']
              if !api_license.nil?
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
          render json: {:error => "401"}, :status => :unauthorized if unauthorized
        end

        def identify_user
          user_id = read_user_id
          user_token = read_user_token
          unauthorized = false

          if !user_id.nil? && (!user_token.nil? || AUTH_CONFIG['bypass_token_verification'])
            user = User.find(user_id)
            if !AUTH_CONFIG['bypass_token_verification']
              if user.token == user_token
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
          render json: {:error => "401"}, :status => :unauthorized if unauthorized
        end

        

      end
  end
end


