# == Schema Information
#
# Table name: profile_ability_languages
#
#  id                 :integer          not null, primary key
#  profile_ability_id :integer
#  language_id        :integer
#  ability_id         :integer
#  profile_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe ProfileAbilityLanguage do
  pending "add some examples to (or delete) #{__FILE__}"
end
