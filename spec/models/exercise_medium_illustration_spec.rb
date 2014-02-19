# == Schema Information
#
# Table name: exercise_illustrations
#
#  id           :integer          not null, primary key
#  exercise_id  :integer
#  illustration :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  token        :string(255)
#

require 'spec_helper'

describe ExerciseMediumIllustration do
  pending "add some examples to (or delete) #{__FILE__}"
end
