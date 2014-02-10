# == Schema Information
#
# Table name: user_ability_languages
#
#  id              :integer          not null, primary key
#  user_ability_id :integer
#  language_id     :integer
#  ability_id      :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe UserAbilityLanguage do
  pending "add some examples to (or delete) #{__FILE__}"
end
