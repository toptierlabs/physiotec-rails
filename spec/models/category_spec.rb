# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  owner_id     :integer
#  context_id   :integer          not null
#  context_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Category do
  pending "add some examples to (or delete) #{__FILE__}"
end
