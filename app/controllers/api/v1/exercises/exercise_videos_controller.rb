module Api
  module V1
    module Exercises
    
      class ExerciseVideosController < Api::V1::ApiController
        before_filter :identify_user,
                      :identify_exercise

        def identify_exercise
          @exercise = case params[:exercise_id].represents_number?
          when true
            Exercise.find(params[:exercise_id])
          when false
            Exercise.find_by_token(params[:exercise_id])
          end
        end

        # GET /exercise_videos
        # GET /exercise_videos.json
        def index
          authorize_request!(:exercise_video, :read)

          exercise_videos = case @exercise.blank?
          when true
            ExerciseVideo.where(token: params[:exercise_id])
          when false
            @exercise.exercise_videos
          end

          render json: { exercises: exercise_videos.as_json }
        end

        # GET /exercise_videos/1
        # GET /exercise_videos/1.json
        def show
          exercise_video = case @exercise.blank?
          when true
            ExerciseVideo.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_videos.find(params[:id])
          end
          authorize_request!(:exercise_video, :read, :model=>@exercise_video)

          render json: exercise_video
        end

        # POST /exercise_videos
        # POST /exercise_videos.json
        def create
          # authorize_request!(:exercise_video, :create)
          params[:exercise_video][:token] = params[:exercise_id]
          @exercise_video = case @exercise.blank?
          when true
            ExerciseVideo.new(params[:exercise_video])
          when false
            @exercise.exercise_videos.new(params[:exercise_video])
          end
          
          # Won't validate so we avoid carrierwave error checking
          if @exercise_video.save(:validate=>false)
            file_name = ActiveRecord::Base.sanitize(params[:exercise_video][:video])

            # Manually update exercise so we avoid carrierwave
            ActiveRecord::Base.connection.execute("update exercise_videos set video=" + file_name+ " where id=" + @exercise_video.id.to_s)
            @exercise_video.reload
            # Maybe reprocess the video to get thumbnails?? Naaah

            render json: @exercise_video, status: :created
          else
            render json: @exercise_video.errors.full_messages, status: :unprocessable_entity
          end
          
        end


        # DELETE /exercise_videos/1
        # DELETE /exercise_videos/1.json
        def destroy
          @exercise_video = case @exercise.blank?
          when true
            ExerciseVideo.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_videos.find(params[:id])
          end
          authorize_request!(:exercise_video, :delete, :model=>@exercise_video)
          @exercise_video.destroy
          head :no_content
        end
      end

    end
  end
end