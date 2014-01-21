module Api
  module V1
    
    class ExerciseVideosController < Api::V1::ApiController
      before_filter :identify_user


      # POST /exercise_videos
      # POST /exercise_videos.json
      def create
        # authorize_request!(:exercise_video, :create)
      
        # Check if the exercise has been created before the upload is complete
        if params[:exercise_video][:exercise_id].nil?
          ex = Exercise.find_by_token(params[:exercise_video][:token])
          if ex.present?
            params[:exercise_video][:exercise_id] = ex.id
          end
        end

        @exercise_video = ExerciseVideo.new(params[:exercise_video])
        
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
        @exercise_video = ExerciseVideo.find(params[:id])
        authorize_request!(:exercise_video, :delete, :model=>@exercise_video)
        @exercise_video.destroy
        head :no_content
      end

    end
  end
end