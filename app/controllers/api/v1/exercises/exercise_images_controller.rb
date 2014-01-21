module Api
  module V1
    
    class ExerciseImagesController < Api::V1::ApiController
      before_filter :identify_user,
                    :identify_exercise

      def identify_exercise
        @exercise = case params[:exercise_id].represents_number?
        when true
          Exercise.find(params[:exercise_id])
        when false
          Exercise.find_by_token(params[:exercise_id]) ||
          Exercise.new(token: params[:exercise_id])
        end
      end

      # GET /exercise_images
      # GET /exercise_images.json
      def index
        authorize_request!(:exercise_image, :read)
        @exercise_images = ExerciseImage.where(:exercise_id=>params[:exercise_id])
        render json: { exercises: @exercise_images.as_json }
      end

      # GET /exercise_images/1
      # GET /exercise_images/1.json
      def show
        @exercise_image = ExerciseImage.find(params[:id])
        authorize_request!(:exercise_image, :read, :model=>@exercise_image)        
        render json: @exercise_image
      end

      # POST /exercise_images
      # POST /exercise_images.json
      def create
        # authorize_request!(:exercise_image, :create)
      
        # Check if the exercise has been created before the upload is complete
        if params[:exercise_image][:exercise_id].nil?
          ex = Exercise.find_by_token(params[:exercise_image][:token])
          if !ex.nil?
            params[:exercise_image][:exercise_id] = ex.id
          end
        end

        @exercise_image = ExerciseImage.new(params[:exercise_image])
        
        # Won't validate so we avoid carrierwave error checking
        if @exercise_image.save(:validate=>false)
          file_name = ActiveRecord::Base.sanitize(params[:exercise_image][:image])

          # Manually update exercise so we avoid carrierwave
          ActiveRecord::Base.connection.execute("update exercise_images set image=" + file_name+ " where id=" + @exercise_image.id.to_s)
          @exercise_image.reload
          # Maybe reprocess the image to get thumbnails?? Naaah

          render json: @exercise_image, status: :created
        else
          render json: @exercise_image.errors.full_messages, status: :unprocessable_entity
        end
        
      end

      # PUT /exercise_images/1
      # PUT /exercise_images/1.json
      def update        
        @exercise_image = ExerciseImage.find(params[:id])
        authorize_request!(:exercise_image, :modify, :model=>@exercise_image)
       
        if @exercise_image.update_attributes(params[:exercise_image])
          head :no_content
        else
          render json: @exercise_image.errors.full_messages, status: :unprocessable_entity
        end
        
      end

      # DELETE /exercise_images/1
      # DELETE /exercise_images/1.json
      def destroy        
        @exercise_image = ExerciseImage.find(params[:id])
        authorize_request!(:exercise_image, :delete, :model=>@exercise_image)
        @exercise_image.destroy
        head :no_content
      end

    end
  end
end