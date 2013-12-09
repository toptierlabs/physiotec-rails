require 'spec_helper' 

describe UserClinic do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:user_clinic).valid?).to be_true
  end

  it "should have a user" do
    expect( FactoryGirl.build(:user_clinic, user: nil).valid? ).to be_false
  end

  it "should return an error if the user is empty" do
    expect( FactoryGirl.build(:user_clinic, user: nil) ).to have(1).error_on(:user_id)
  end

  it "should have a clinic" do
    expect( FactoryGirl.build(:user_clinic, clinic: nil).valid? ).to be_false
  end

  it "should return an error if the user is empty" do
    expect( FactoryGirl.build(:user_clinic, clinic: nil) ).to have(1).error_on(:clinic_id)
  end
end 