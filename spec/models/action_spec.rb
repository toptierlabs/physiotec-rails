require 'spec_helper'

describe Action do
  it "has a valid factory" do
    expect( FactoryGirl.build(:action).valid? ).to be_true
  end

  it "should have a name" do
    expect( FactoryGirl.build(:action, name: '').valid? ).to be_false
  end

  it "should return an error if the name is empty" do
    expect( FactoryGirl.build(:action, name: '') ).to have(1).error_on(:name)
  end
  
  it "name should be unique" do
    action = FactoryGirl.create(:action)
    new_action = action.dup

    expect(new_action.valid?).to be_false
  end  
end



