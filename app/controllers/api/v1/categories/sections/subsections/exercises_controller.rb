module Api
  module V1
    module Categories
      module Sections
        module Subsections    
          class ExercisesController < Api::V1::ApiController

            # GET modules/:id/section/:id/subsections/:id/exercises
            # GET modules/:id/section/:id/subsections/:id/exercises.json
            def index
              render json: { exercises: @exercises.as_json }
            end

            # GET modules/:id/section/:id/subsections/:id/exercises/1
            # GET modules/:id/section/:id/subsections/:id/exercises/1.json
            def show
              render json: @exercise.as_json
            end

            # POST modules/:id/section/:id/subsections/:id/exercise
            # POST modules/:id/section/:id/subsections/:id/exercise.json
            def create
              # Recieves the following information and then creates an exercise:
              # { "exercise":
              #   { "description": string ,
              #     "exercise_medium_id": integer,
              #     "keywords":[Sring],
              #     "short_title":String,
              #     "title"String,
              #   }
              # }
              # The description, keywords and title attributes are translatable.
              # So, It also gives you access to methods: title_fr, title_en, etc.
              # for each translatable attribute
                
              @exercise = ExerciseMedium.new(params[:exercise_medium])
              @exercise.api_license = @api_license
              @exercise.owner = @current_user

              if @exercise.save
                render json: @exercise, status: :created
              else
                render json: @exercise.errors.full_messages, status: :unprocessable_entity
              end
            end

            # PUT modules/:id/section/:id/subsections/:id/exercise/1
            # PUT modules/:id/section/:id/subsections/:id/exercise/1.json
            def update
              # Recieves the following information and then updates an exercise:
              # { "exercise":
              #   { "id":integer, exercise_id
              #     "description": string ,
              #     "exercise_medium_id": integer,
              #     "keywords":[Sring],
              #     "short_title":String,
              #     "title"String,
              #   }
              # }
              if @exercise.update_attributes(params[:exercise_medium])
                head :no_content
              else
                render json: @exercise.errors.full_messages, status: :unprocessable_entity
              end
            end

            # DELETE modules/:id/section/:id/subsections/:id/exercise/1
            # DELETE modules/:id/section/:id/subsections/:id/exercise/1.json
            def destroy        
              if @exercise.destroy
                head :no_content
              else
                render json: @exercise.errors.full_messages, status: :unprocessable_entity
              end
            end

            #POST modules/:id/section/:id/subsections/:id/exercise/1/subsections
            def add_to_subsection
              subsection = Subsection.find(params[:subsection_id])
              subsection.exercises << @exercise
              head :no_content
            end

            #DELETE modules/:id/section/:id/subsections/:id/exercise/1/subsections/:id
            def remove_from_subsection
              subsection = Subsection.find(params[:subsection_id])
              subsection.exercises.delete @exercise
              head :no_content
            end

          end
        end
      end
    end
  end
end