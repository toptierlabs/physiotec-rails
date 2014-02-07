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

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
