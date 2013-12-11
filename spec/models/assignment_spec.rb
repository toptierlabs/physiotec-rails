require 'spec_helper' 

describe Assignment do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:assignment).valid?).to be_true
  end

  it "should have a user" do
    expect( FactoryGirl.build(:assignment, user: nil).valid? ).to be_false
  end

  it "should return an error if the user is empty" do
    expect( FactoryGirl.build(:assignment, user: nil) ).to have(1).error_on(:user)
  end

  it "should have a assignable entity" do
    expect( FactoryGirl.build(:assignment, assignable: nil).valid? ).to be_false
  end

  it "should return an error if the assignable entity is empty" do
    expect( FactoryGirl.build(:assignment, assignable: nil) ).to have(1).error_on(:assignable)
  end
    
end 
