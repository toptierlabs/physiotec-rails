require 'spec_helper'

describe ScopeGroup do
  it "has a valid factory" do
    expect { FactoryGirl.build(:scope_group).valid? }.to be_true
  end

  it "should have a name" do
    expect(FactoryGirl.build(:scope_group, name: '').valid?).to be_false
  end

  it "should return an error if the name is empty" do
    expect(FactoryGirl.build(:scope_group, name: '')).to have(1).error_on(:name)
  end
  
  it "should not be valid if we have another scope group with the same name for the same api license" do
    scope_group = FactoryGirl.create(:scope_group)
    new_scope_group = scope_group.dup

    expect(new_scope_group.valid?).to be_false
  end

  it "can exist two scope groups with the same name on different api licenses" do
    scope_group = FactoryGirl.create(:scope_group)
    new_sg = scope_group.dup
    new_sg.api_license = FactoryGirl.create(:api_license, name: 'New API')

    expect(new_sg.valid?).to be_true
  end

  
end



