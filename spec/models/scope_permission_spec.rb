require 'spec_helper'

describe ScopePermission do
  it "has a valid factory" do
    expect { FactoryGirl.build(:scope_permission).valid? }.to be_true
  end

  it "should have a permission" do
    expect(FactoryGirl.build(:scope_permission, permission: nil).valid?).to be_false
  end

  it "should return an error if the permission is empty" do
    expect(FactoryGirl.build(:scope_permission, permission: nil)).to have(1).error_on(:permission)
  end

  it "should have a action" do
    expect(FactoryGirl.build(:scope_permission, action: nil).valid?).to be_false
  end

  it "should return an error if the action is empty" do
    expect(FactoryGirl.build(:scope_permission, action: nil)).to have(1).error_on(:action)
  end
  
end



