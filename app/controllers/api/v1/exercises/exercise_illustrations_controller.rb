module Api
  module V1
    
    class ExerciseIllustrationsController < Api::V1::ApiController
      before_filter :identify_user

      # GET /exercise_illustrations
      # GET /exercise_illustrations.json
      def index
        authorize_request!(:exercise_illustration, :read)
        @exercise_illustrations = ExerciseIllustration.where(:exercise_id=>params[:exercise_id])
        render json: { exercises: @exercise_illustrations.as_json }
      end

      # GET /exercise_illustrations/1
      # GET /exercise_illustrations/1.json
      def show
        @exercise_illustration = ExerciseIllustration.find(params[:id])
        authorize_request!(:exercise_illustration, :read, :model=>@exercise_illustration)        
        render json: @exercise_illustration
      end

      # POST /exercise_illustrations
      # POST /exercise_illustrations.json
      def create
        # authorize_request!(:exercise_illustration, :create)
      
        # Check if the exercise has been created before the upload is complete
        if params[:exercise_illustration][:exercise_id].nil?
          ex = Exercise.find_by_token(params[:exercise_illustration][:token])
          if !ex.nil?
            params[:exercise_illustration][:exercise_id] = ex.id
          end
        end

        @exercise_illustration = ExerciseIllustration.new(params[:exercise_illustration])
        
        # Won't validate so we avoid carrierwave error checking
        if @exercise_illustration.save(:validate=>false)
          file_name = ActiveRecord::Base.sanitize(params[:exercise_illustration][:illustration])

          # Manually update exercise so we avoid carrierwave
          ActiveRecord::Base.connection.execute("update exercise_illustrations set illustration=" + file_name+ " where id=" + @exercise_illustration.id.to_s)
          @exercise_illustration.reload
          # Maybe reprocess the image to get thumbnails?? Naaah

          render json: @exercise_illustration, status: :created
        else
          render json: @exercise_illustration.errors.full_messages, status: :unprocessable_entity
        end
        
      end

      # PUT /exercise_illustrations/1
      # PUT /exercise_illustrations/1.json
      def update        
        @exercise_illustration = ExerciseIllustration.find(params[:id])
        authorize_request!(:exercise_illustration, :modify, :model=>@exercise_illustration)
       
        if @exercise_illustration.update_attributes(params[:exercise_illustration])
          head :no_content
        else
          render json: @exercise_illustration.errors.full_messages, status: :unprocessable_entity
        end
        
      end

      # DELETE /exercise_illustrations/1
      # DELETE /exercise_illustrations/1.json
      def destroy        
        @exercise_illustration = ExerciseIllustration.find(params[:id])
        authorize_request!(:exercise_illustration, :delete, :model=>@exercise_illustration)
        @exercise_illustration.destroy
        head :no_content
      end

    end
  end
end