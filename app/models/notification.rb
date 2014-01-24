class Notification < ActiveRecord::Base
  attr_accessible :extra, :message, :message_id, :subject, :topic_arn
end
