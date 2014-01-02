module Api
  module V1
    
    class ExercisesController < Api::V1::ApiController
      before_filter :identify_user

      # GET /exercises
      # GET /exercises.json
      def index
        authorize_request!(:exercise, :read)
        @exercises = Exercise.where(:api_license_id => @api_license.id)
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
        I18n.locale = params[:exercise][:translations_attributes].first[:locale]      
        @exercise = Exercise.new(params[:exercise])
        @exercise.api_license_id = @api_license.id
        @exercise.owner = @current_user
        I18n.locale = :en
        if @exercise.save
          render json: @exercise, status: :created
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
      end

      # PUT /exercise/1
      # PUT /exercise/1.json
      def update        
        @exercise = Exercise.find(params[:id])
        authorize_request!(:exercise, :modify, :model=>@exercise)
        if @exercise.update_attributes(params[:exercise].except(:api_license_id))
          head :no_content
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
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