require 'spec_helper' 

describe UserProfile do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:user_profile).valid?).to be_true
  end

  it "should have a profile" do
    expect( FactoryGirl.build(:user_profile, profile: nil).valid? ).to be_false
  end

  it "should return an error if the profile is empty" do
    expect( FactoryGirl.build(:user_profile, profile: nil) ).to have(1).error_on(:profile)
  end
    
  it "should have a user" do
    expect( FactoryGirl.build(:user_profile, user: nil).valid? ).to be_false
  end

  it "should return an error if the scope group is empty" do
    expect( FactoryGirl.build(:user_profile, user: nil) ).to have(1).error_on(:user)
  end

  it "should be invalid if we have the same profile and user in two records" do
    sp = FactoryGirl.create(:user_profile) 
    sp_new = sp.dup
    expect( sp_new.valid? ).to be_false
  end
end 