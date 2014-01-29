module Api
  module V1
    
    class NotificationsController < ApplicationController
      # POST /notifications
      # POST /notifications.json
      def create
        aws_request_body = JSON.parse(request.body.read())
        puts aws_request_body
        aws_message = JSON.parse(aws_request_body["Message"])
        aws_et_job_id= aws_message["jobId"]

        @notification = Notification.new
        @notification.message_id = aws_request_body["MessageId"]
        @notification.topic_arn = aws_request_body["TopicArn"]
        @notification.subject = aws_request_body["Subject"]
        @notification.message = aws_request_body["Message"]
        @notification.extra = aws_request_body.to_json

        

        if @notification.save
          store_status(aws_et_job_id, aws_message["state"].upcase)
          
          render json: @notification, status: :created
        else
          render json: @notification.errors.full_messages, status: :unprocessable_entity
        end
      end

      def index 
        render json: Notification.all
      end

      private 

        def store_status(job_id, state)
          video = ExerciseVideo.where(job_id: job_id).first
        

          if ((state == "COMPLETED") || (state ==  "WARNING"))   
            video.status = ExerciseVideo::STATES[:completed]
          elsif (aws_message["state"].upcase == "ERROR")
            video.status = ExerciseVideo::STATES[:failed]
          end
          video.save

        end 
    end
  end
end