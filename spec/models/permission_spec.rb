# == Schema Information
#
# Table name: permissions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  model_name       :string(255)
#  minimum_scope_id :integer
#  maximum_scope_id :integer
#

require 'spec_helper'

describe Permission do
  it "has a valid factory" do
    expect { FactoryGirl.build(:permission).valid? }.to be_true
  end

  it "should have a name" do
    expect(FactoryGirl.build(:permission, name: '').valid?).to be_false
  end

  it "should return an error if the name is empty" do
    expect(FactoryGirl.build(:permission, name: '')).to have(1).error_on(:name)
  end
  
  it "should not be valid if we have another permission with the same name for the same api license" do
    perm = FactoryGirl.create(:permission)
    new_permission = perm.dup

    expect(new_permission.valid?).to be_false
  end

  it "can exist two permissions with the same name on different api licenses" do
    perm = FactoryGirl.create(:permission)
    new_permission = perm.dup
    new_permission.api_license = FactoryGirl.create(:api_license, name: 'New API')

    expect(new_permission.valid?).to be_true
  end

  it "#name_as_sym should return a symlink from the name" do
    expect(FactoryGirl.build(:permission, name: 'Perm123').name_as_sym).to eq(:perm123)
  end

  it "#name_as_sym should return a symlink from the name with spaces" do
    expect(FactoryGirl.build(:permission, name: '  weirdPerms  ').name_as_sym).to eq(:_weirdperms_)
  end

  it "#name_as_sym should return a symlink from the name with spaces in the middle" do
    expect(FactoryGirl.build(:permission, name: 'perm perm').name_as_sym).to eq(:perm_perm)
  end

  
end



