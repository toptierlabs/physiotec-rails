require 'spec_helper' 

describe ProfileAssignment do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:profile_assignment).valid?).to be_true
  end

  it "should have a profile" do
    expect( FactoryGirl.build(:profile_assignment, profile: nil).valid? ).to be_false
  end

  it "should return an error if the profile is empty" do
    expect( FactoryGirl.build(:profile_assignment, profile: nil) ).to have(1).error_on(:profile_id)
  end
    
  it "should have a destinaton profile" do
    expect( FactoryGirl.build(:profile_assignment, destination_profile: nil).valid? ).to be_false
  end

  it "should return an error if the destination profile is empty" do
    expect( FactoryGirl.build(:profile_assignment, destination_profile: nil) ).to have(1).error_on(:destination_profile_id)
  end
end 