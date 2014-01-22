module Api
  module V1
    module Exercises
    
      class ExerciseIllustrationsController < Api::V1::ApiController
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

        # GET /exercise_illustrations
        # GET /exercise_illustrations.json
        def index
          authorize_request!(:exercise_illustration, :read)

          exercise_illustrations = case @exercise.blank?
          when true
            ExerciseIllustration.where(token: params[:exercise_id])
          when false
            @exercise.exercise_illustrations
          end

          render json: { exercises: exercise_illustrations.as_json }
        end

        # GET /exercise_illustrations/1
        # GET /exercise_illustrations/1.json
        def show
          exercise_illustration = case @exercise.blank?
          when true
            ExerciseIllustration.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_illustrations.find(params[:id])
          end
          authorize_request!(:exercise_illustration, :read, :model=>@exercise_illustration)

          render json: exercise_illustration
        end

        # POST /exercise_illustrations
        # POST /exercise_illustrations.json
        def create
          # authorize_request!(:exercise_illustration, :create)
          params[:exercise_illustration][:token] = params[:exercise_id]
          @exercise_illustration = case @exercise.blank?
          when true
            ExerciseIllustration.new(params[:exercise_illustration])
          when false
            @exercise.exercise_illustrations.new(params[:exercise_illustration])
          end
          
          # Won't validate so we avoid carrierwave error checking
          if @exercise_illustration.save(:validate=>false)
            file_name = ActiveRecord::Base.sanitize(params[:exercise_illustration][:illustration])

            # Manually update exercise so we avoid carrierwave
            ActiveRecord::Base.connection.execute("update exercise_illustrations set illustration=" + file_name+ " where id=" + @exercise_illustration.id.to_s)
            @exercise_illustration.reload
            # Maybe reprocess the illustration to get thumbnails?? Naaah

            render json: @exercise_illustration, status: :created
          else
            render json: @exercise_illustration.errors.full_messages, status: :unprocessable_entity
          end
          
        end


        # DELETE /exercise_illustrations/1
        # DELETE /exercise_illustrations/1.json
        def destroy
          @exercise_illustration = case @exercise.blank?
          when true
            ExerciseIllustration.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_illustrations.find(params[:id])
          end
          authorize_request!(:exercise_illustration, :delete, :model=>@exercise_illustration)
          @exercise_illustration.destroy
          head :no_content
        end
      end

    end
  end
end