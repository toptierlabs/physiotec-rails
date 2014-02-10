module Api
  module V1
    
    class ExercisesController < Api::V1::ApiController
      before_filter :identify_exercise, except: [:index, :create]

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
        authorize_request!(:exercise, :read, :model=>@exercise)        
        render json: @exercise.as_json(:include=>[:exercise_images,
                                                  :exercise_illustrations,
                                                  :exercise_videos,
                                                  subsections:{methods: [:name],
                                                               include: {section:{include: {module: {methods: :name}},
                                                                                  methods: :name}}}])
      end

      # POST /exercise
      # POST /exercise.json
      def create
        authorize_request!(:exercise, :create)

        params[:exercise][:translations_attributes].each do |v|
          authorize_request!(:exercise,
                            :translate,
                            scopes: [ v[:locale],
                                      params[:exercise][:context_type]]
                            )
        end
        validate_and_sanitize_context(params[:exercise])

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
        authorize_request!(:exercise, :modify, :model=>@exercise)
        params[:exercise][:translations_attributes].each do |v|
          authorize_request!(:exercise,
                            :translate,
                            scopes: [ v[:locale],
                                      params[:exercise][:context_type]],
                            model: @exercise
                            )
        end
        validate_and_sanitize_context(params[:exercise])

        I18n.locale = params[:exercise][:translations_attributes].first[:locale]
        if @exercise.update_attributes(params[:exercise])
          head :no_content
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
        I18n.locale = :en
      end

      # DELETE /exercise/1
      # DELETE /exercise/1.json
      def destroy        
        authorize_request!(:exercise, :delete, :model=>@exercise)
        if @exercise.destroy
          head :no_content
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
      end

      #POST /exercise/1/subsections
      def add_to_subsection
        subsection = Subsection.find(params[:subsection_id])
        subsection.exercises << @exercise
        head :no_content
      end

      #DELETE /exercise/1/subsections/:id
      def remove_from_subsection
        subsection = Subsection.find(params[:subsection_id])
        subsection.exercises.delete @exercise
        head :no_content
      end

      private

      def identify_exercise
        @exercise = @api_license.exercises.find(params[:id])
      end

    end
  end
end