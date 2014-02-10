# == Schema Information
#
# Table name: user_contexts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe UserContext do
  pending "add some examples to (or delete) #{__FILE__}"
end
