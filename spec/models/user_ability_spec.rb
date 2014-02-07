# == Schema Information
#
# Table name: user_abilities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ability_id :integer
#  scope_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe UserAbility do
  pending "add some examples to (or delete) #{__FILE__}"
end
