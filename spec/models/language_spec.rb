# == Schema Information
#
# Table name: languages
#
#  id             :integer          not null, primary key
#  api_license_id :integer
#  locale         :string(255)
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Language do
  pending "add some examples to (or delete) #{__FILE__}"
end
