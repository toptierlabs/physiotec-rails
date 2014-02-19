# == Schema Information
#
# Table name: exercise_videos
#
#  id          :integer          not null, primary key
#  exercise_id :integer
#  video       :string(255)
#  token       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_id      :string(255)
#  status      :string(255)
#

require 'spec_helper'

describe ExerciseMediumVideo do
  pending "add some examples to (or delete) #{__FILE__}"
end
