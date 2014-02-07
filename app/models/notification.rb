# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  message_id :string(255)
#  topic_arn  :string(255)
#  subject    :string(255)
#  message    :text
#  extra      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base
  attr_accessible :extra, :message, :message_id, :subject, :topic_arn
end
