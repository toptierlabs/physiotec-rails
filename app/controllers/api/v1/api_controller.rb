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
      before_filter :identify_user, :except=>[:login, :cors_access_control]
      before_filter :load_resources_and_authorize_request

      def cors_access_control
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'X-URL-HASH, X-API-KEY, X-USER-ID, X-USER-TOKEN, Origin, X-Requested-With, Content-Type, Accept, Authorization'
        head(:ok) if request.request_method == "OPTIONS"
      end


  protected

        def authorize_requestv2(action, entity, params = {})
          check_translations = params[:check_translations] || false
          entity_class = case entity
          when is_a?(String)
            entity.singularize.camelize.constantize
          when is_a?(Symbol)
            entity.to_s.singularize.camelize.constantize
          else
            entity.class
          end
          unless AUTH_CONFIG['super_user'] || @current_user.can?(action, entity)
            raise PermissionsHelper::ForbiddenAccess.new 
          end

          if check_translations && entity_class.translates?
            globalized_attributes = entity.class.globalize_attribute_names
            globalized_attributes -= params["#{entity_class.name.constantize}"].keys
            if globalized_attributes.present?
              globalized_attributes.map{ |v| v.split("_").last.to_sym }
              translate_actions = Action.where(locale: globalized_attributes)
              translate_actions.each do |v|
                unless @current_user.can? v.name, entity

                  raise PermissionsHelper::ForbiddenAccess.new 
                end
              end
            end
          end
          true
        end

        def load_resources_and_authorize_request

          # Sanitize the params, gets the action and the permission from params
          controller_action = params[:action].to_sym
          action = (controller_action == :index) ? :show : controller_action

          puts request.path_info
          puts params.to_json

          # Load resources. The Class name of the elements to load are obtained from param[:controller].
          # The ids of the # elements are read from params[:resource_id]

          ordered_instances = request.path_info.split("/").drop(3) # drops "/api/v1" from the URL
          remove_from_ordered_instances = params.select{ |k| k.ends_with? "_id" }.values
          ordered_instances -= remove_from_ordered_instances

          # ordered_instances = params[:controller].split("/").drop(2) 
          # puts ordered_instances
          last_resource = ordered_instances.pop # Last object will be read at the end, according to the action

          authorize_requestv2(action, last_resource)

          # Start getting the objects
          object_colleciton = @api_license # Place to search the first object
          ordered_instances.each do |v|
            element_id = params["#{v.singularize}_id"]
            element = object_colleciton.instance_eval("#{v}.find_by_id(#{element_id})")

            # Patch to load exercise correctly
            element ||= object_colleciton.instance_eval("#{v}.find_by_token(#{element_id})")
            element ||= object_colleciton.instance_eval("#{v}.find_by_name(#{element_id})")

            authorize_requestv2(:show, element) if element.present?

            # Element holds the object with class v and id element_id
            # Now the next object to load must be loaded from element
            object_colleciton = element
          end

          # Loads the last element according to the controller action
          case controller_action
          when :index #loads the collection
            puts object_colleciton.as_json
            instance = object_colleciton.send(last_resource) # calls method with name last_resource
            instance_variable_set("@#{last_resource}", instance)
          when :show || :update || :destroy
            instance = nil
            # Patch to load exercise resources correctly
            if last_resource.starts_with? "exercise_"
              instance = object_colleciton.instance_eval("#{last_resource}.find_by(#{params[:id]})")
              instance ||= last_resource.singularize.camelize.constantize.find(params[:id])
            else
              instance = object_colleciton.instance_eval("#{last_resource}.find(#{params[:id]})")
            end

            authorize_requestv2(action, instance, check_translations: true)

            instance_variable_set("@#{last_resource.singularize}", instance)
          end

        end

        def authorize_request(permission, action, params)
          entity = params[:model] if params.present? && params[:model].present?
          AUTH_CONFIG['super_user'] || @current_user.can?(action, entity, params)
        end

        def authorize_request!
          if authorize_request(permission, action, scopes)
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
          #render json: {:error => "Not Authorized"}, :status => :unauthorized if unauthorized
          @api_license = ApiLicense.first
        end

        def identify_user
          user_id = read_user_id
          user_token = read_user_token
          unauthorized = false

          if user_id.present? && (user_token.present? || AUTH_CONFIG['bypass_token_verification'])
            user = User.find(user_id)
            if !AUTH_CONFIG['bypass_token_verification']
              if user.session_token == user_token
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
          #render json: {:error => "Not Authorized"}, :status => :unauthorized if unauthorized
          @current_user = User.first
        end

        

      end
  end
end