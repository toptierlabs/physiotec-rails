require 'spec_helper'

describe Scope do
  it "has a valid factory" do
    expect { FactoryGirl.build(:scope).valid? }.to be_true
  end

  it "should have a name" do
    expect(FactoryGirl.build(:scope, name: '').valid?).to be_false
  end

  it "should return an error if the name is empty" do
    expect(FactoryGirl.build(:scope, name: '')).to have(1).error_on(:name)
  end
  
  it "should not be valid if we have another scope  with the same name for the same scope group" do
    scope = FactoryGirl.create(:scope)
    new_scope = scope.dup

    expect(new_scope.valid?).to be_false
  end

  it "can exist two scope groups with the same name on different scope groups" do
    scope = FactoryGirl.create(:scope)
    new_scope = scope.dup
    new_scope.scope_group = FactoryGirl.create(:scope_group)

    expect(new_scope.valid?).to be_true
  end

  
end



