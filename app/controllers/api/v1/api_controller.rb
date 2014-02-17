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
      #before_filter :authorize_requestv2

      def cors_access_control
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'X-URL-HASH, X-API-KEY, X-USER-ID, X-USER-TOKEN, Origin, X-Requested-With, Content-Type, Accept, Authorization'
        head(:ok) if request.request_method == "OPTIONS"
      end


  protected

        def authorize_requestv2(model = nil)

          #{"format"=>"json", "action"=>"index", "controller"=>"api/v1/users/abilities", "user_id"=>"1"}

          # Sanitize the params, gets the action and the permission from params
          puts params.as_json
          action = params[:action].to_sym

          # Get the instance that may load from resources, to accomplish
          # this action, it searches all keys in params that end with _id
          instance_to_load_ids = params.select{ |k,v| k.ends_with?("_id") }

          # Loads the instances depending on the URL order
          ordered_instances = params[:controller].split("/").drop(2) # drops "api/v1" from the URL
          ordered_instances.map!(&:singularize)

          puts ordered_instances.as_json
          puts '*'*40
          puts instance_to_load_ids.as_json
          loaded_instances = {}
          _element = nil
          _parent_element = nil
          ordered_instances.each_cons(2) do |v, w|
            if loaded_instances[v].blank?
              _element = @current_user.method("#{v.pluralize}.find(#{instance_to_load_ids[v+"_id"]})").call
              self.instance_variable_set("@selected_#{v}", _element)
              loaded_instances[v] = true
            end
            if loaded_instances[w].blank?
              _parent_element = self.instance_variable_get("@selected_#{v}")
              _element = _parent_element.method("#{w.pluralize}.find(#{instance_to_load_ids[w"_id"]})").call
              self.instance_variable_set("@selected_#{w}", _element)
              loaded_instances[w] = true
            end
            puts loaded_instances.to_json
          end




          # Load class name and class
          class_name =  params[:controller].split("/").drop(2)
          class_name = class_name.map!(&:singularize).join("_").camelize
          class_instance = class_name.constantize

          # Load Resource
          minified_class_name = class_name.underscore.pluralize
          if action == :index
            instance = @current_user.method(minified_class_name.to_sym).call
            self.instance_variable_set("@#{minified_class_name.pluralize}", instance)
          elsif (action != :create) && params[:id].present?
            instance = @current_user.method("#{minified_class_name..find(params[:id])}".to_sym).call
            self.instance_variable_set("@#{minified_class_name}", instance)
          end

          # # If model is translatable then it searches for translation locales
          # # sent in the params attributes
          # permission = Permission.find_by_model_name(model_name)
          # if permission.is_translatable?
          #   localized_attr = permission.model_class.globalize_attribute_names
          #   recv_localized_attr = params[permission].keys.select{ |v| localized_attr.include? v }
          #   recv_localized_attr.map!{ |v| v.split("_").last }.uniq!
          #   actions = Action.where(locale: recv_localized_attr)
          # end

          
          # element = model || permission
          # puts @current_user.can? action, element
        end

        def authorize_request(permission, action, params)
          entity = params[:model] if params.present? && params[:model].present?
          AUTH_CONFIG['super_user'] || @current_user.can?(action, entity, params)
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