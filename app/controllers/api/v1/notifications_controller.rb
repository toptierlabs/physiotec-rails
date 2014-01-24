module Api
  module V1
    
    class NotificationsController < ApplicationController
      # POST /notifications
      # POST /notifications.json
      def create
        puts params
        @notification = Notification.new
        @notification.message_id = params["MessageId"]
        @notification.topic_arn = params["TopicArn"]
        @notification.subject = params["Subject"]
        @notification.message = params["Message"]
        @notification.extra = params.to_json


        if @notification.save
          render json: @notification, status: :created
        else
          render json: @notification.errors.full_messages, status: :unprocessable_entity
        end
      end

      def index 
        render json: Notification.all
      end
    end
  end
end