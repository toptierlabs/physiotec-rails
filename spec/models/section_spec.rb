# == Schema Information
#
# Table name: sections
#
#  id               :integer          not null, primary key
#  category_id      :integer          not null
#  section_datum_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Section do
  pending "add some examples to (or delete) #{__FILE__}"
end
