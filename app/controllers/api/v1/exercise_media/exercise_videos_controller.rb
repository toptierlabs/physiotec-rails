module Api
  module V1
    module Exercises
    
      class ExerciseVideosController < Api::V1::ApiController

        # GET /exercise_videos
        # GET /exercise_videos.json
        def index         

          @exercise_videos = case @exercise.blank?
          when true
            ExerciseVideo.where(token: params[:exercise_id])
          when false
            @exercise.exercise_videos
          end

          render json: { exercises: @exercise_videos.as_json }
        end

        # GET /exercise_videos/1
        # GET /exercise_videos/1.json
        def show
          @exercise_video = case @exercise.blank?
          when true
            ExerciseVideo.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_videos.find(params[:id])
          end           

          render json: @exercise_video
        end

        # POST /exercise_videos
        # POST /exercise_videos.json
        def create
          # 
          params[:exercise_video][:token] = params[:exercise_id]
          @exercise_video = case @exercise.blank?
          when true
            ExerciseVideo.new(params[:exercise_video])
          when false
            @exercise.exercise_videos.new(params[:exercise_video])
          end
          
          # Won't validate so we avoid carrierwave error checking
          if @exercise_video.save(:validate=>false)
            file_name = params[:exercise_video][:video]

            # Manually update exercise so we avoid carrierwave
            @exercise_video.update_column(:video, file_name)
            
            @exercise_video.video.convert_video(file_name)
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
          
          @exercise_video.destroy
          head :no_content
        end
      end

    end
  end
end