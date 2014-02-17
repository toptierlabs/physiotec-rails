module Api
  module V1
    
    class ExercisesController < Api::V1::ApiController

      # GET /exercises
      # GET /exercises.json
      def index
        render json: { exercises: @exercises.as_json }
      end

      # GET /exercises/1
      # GET /exercises/1.json
      def show
        
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
        @exercise = Exercise.new(params[:exercise])
        @exercise.api_license = @api_license
        @exercise.owner = @current_user

        if @exercise.save
          render json: @exercise, status: :created
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
      end

      # PUT /exercise/1
      # PUT /exercise/1.json
      def update
        if @exercise.update_attributes(params[:exercise])
          head :no_content
        else
          render json: @exercise.errors.full_messages, status: :unprocessable_entity
        end
      end

      # DELETE /exercise/1
      # DELETE /exercise/1.json
      def destroy        
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

    end
  end
end