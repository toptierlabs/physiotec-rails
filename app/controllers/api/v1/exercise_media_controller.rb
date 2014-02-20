module Api
  module V1
    
    class ExerciseMediaController < Api::V1::ApiController

      # GET /exercise_media
      # GET /exercise_media.json
      def index
        render json: { exercise_media: @exercise_media.as_json }
      end

      # GET /exercise_media/1
      # GET /exercise_media/1.json
      def show
        
        render json: @exercise_medium.as_json(:include=>[:exercise_medium_images,
                                                  :exercise_medium_illustrations,
                                                  :exercise_medium_videos,
                                                  subsections:{methods: [:name],
                                                               include: {section:{include: {module: {methods: :name}},
                                                                                  methods: :name}}}])
      end

      # POST /exercise_media
      # POST /exercise_media.json
      def create
        @exercise_medium = exercise_medium.new(params[:exercise_medium])
        @exercise_medium.api_license = @api_license
        @exercise_medium.owner = @current_user

        if @exercise_medium.save
          render json: @exercise_medium, status: :created
        else
          render json: @exercise_medium.errors.full_messages, status: :unprocessable_entity
        end
      end

      # PUT /exercise_media/1
      # PUT /exercise_media/1.json
      def update
        if @exercise_medium.update_attributes(params[:exercise_medium])
          head :no_content
        else
          render json: @exercise_medium.errors.full_messages, status: :unprocessable_entity
        end
      end

      # DELETE /exercise_media/1
      # DELETE /exercise_media/1.json
      def destroy        
        if @exercise_medium.destroy
          head :no_content
        else
          render json: @exercise_medium.errors.full_messages, status: :unprocessable_entity
        end
      end

    end
  end
end