module Api
  module V1
    
    class ExercisesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /exercises
      # GET /exercises.json
      def index
        authorize_request!(:exercise, :read)
        @exercises = Exercise.on_api_license(@api_license)
        render json: { exercises: @exercises.as_json }
      end

      # GET /exercises/1
      # GET /exercises/1.json
      def show
        @exercise = Exercise.find(params[:id])
        authorize_request!(:exercise, :read, :model=>@exercise)        
        render json: @exercise
      end

      # POST /exercise
      # POST /exercise.json
      def create
        authorize_request!(:exercise, :create)

        params[:exercise][:translations_attributes].each do |v|
          authorize_request!(:translate,
                            :create,
                            scopes: [ v[:locale],
                                      params[:exercise][:context_type]]
                            )
        end
        # Update the context_id
        case params[:exercise][:context_type]
        when "Own"
          params[:exercise][:context_type] = User.name
          params[:exercise][:context_id] = @current_user.id
        when "ApiLicense"
          params[:exercise][:context_id] = @api_license.id
        end
        @exercise = Exercise.new(params[:exercise])
        @exercise.api_license = @api_license
        @exercise.owner = @current_user

        I18n.locale = params[:exercise][:translations_attributes].first[:locale]
        if @exercise.save
          render json: @exercise, status: :created
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
        I18n.locale = :en
      end

      # PUT /exercise/1
      # PUT /exercise/1.json
      def update        
        @exercise = Exercise.find(params[:id])
        authorize_request!(:exercise, :modify, :model=>@exercise)
        params[:exercise][:translations_attributes].each do |v|
          authorize_request!(:translate,
                            :create,
                            scopes: [ v[:locale],
                                      params[:exercise][:context_type]],
                            model: @exercise
                            )
        end
        # Update the context_id
        case params[:exercise][:context_type]
        when "Own"
          params[:exercise][:context_type] = User.name
          params[:exercise][:context_id] = @current_user.id
        when "ApiLicense"
          params[:exercise][:context_id] = @api_license.id
        end
        I18n.locale = params[:exercise][:translations_attributes].first[:locale]
        if @exercise.update_attributes(params[:exercise].except(:api_license_id))
          head :no_content
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
        I18n.locale = :en
      end

      # DELETE /exercise/1
      # DELETE /exercise/1.json
      def destroy        
        @exercise = Exercise.find(params[:id])
        authorize_request!(:exercise, :delete, :model=>@exercise)
        @exercise.destroy
        head :no_content
      end

    end
  end
end