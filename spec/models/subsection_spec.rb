# == Schema Information
#
# Table name: subsections
#
#  id                  :integer          not null, primary key
#  section_id          :integer          not null
#  subsection_datum_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe Subsection do
  pending "add some examples to (or delete) #{__FILE__}"
end
