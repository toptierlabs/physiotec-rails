# == Schema Information
#
# Table name: section_data
#
#  id             :integer          not null, primary key
#  api_license_id :integer          not null
#  context_id     :integer          not null
#  context_type   :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe SectionDatum do
  pending "add some examples to (or delete) #{__FILE__}"
end
