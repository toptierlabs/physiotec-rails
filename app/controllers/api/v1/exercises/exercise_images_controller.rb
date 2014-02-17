module Api
  module V1
    module Exercises
    
      class ExerciseImagesController < Api::V1::ApiController

        # GET /exercise_images
        # GET /exercise_images.json
        def index  

          @exercise_images = case @exercise.blank?
          when true
            ExerciseImage.where(token: params[:exercise_id])
          when false
            @exercise.exercise_images
          end

          render json: { exercises: @exercise_images.as_json }
        end

        # GET /exercise_images/1
        # GET /exercise_images/1.json
        def show
          @exercise_image = case @exercise.blank?
          when true
            ExerciseImage.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_images.find(params[:id])
          end
          

          render json: @exercise_image
        end

        # POST /exercise_images
        # POST /exercise_images.json
        def create
          params[:exercise_image][:token] = params[:exercise_id]
          @exercise_image = case @exercise.blank?
          when true
            ExerciseImage.new(params[:exercise_image])
          when false
            @exercise.exercise_images.new(params[:exercise_image])
          end
          
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


        # DELETE /exercise_images/1
        # DELETE /exercise_images/1.json
        def destroy
          @exercise_image = case @exercise.blank?
          when true
            ExerciseImage.where(token: params[:exercise_id], id: params[:id])
          when false
            @exercise.exercise_images.find(params[:id])
          end
          
          @exercise_image.destroy
          head :no_content
        end
      end

    end
  end
end