require 'spec_helper' 

describe ApiLicense do 

  context "Valid API license" do
    it "has a valid factory" do
      FactoryGirl.create(:api_license).should be_valid
    end
  end
  
  context "Invalid API license" do
    it "should not work with an empty name" do
      FactoryGirl.build(:api_license, :name=>'').should_not be_valid
    end
    it "should not work with an empty description" do
      FactoryGirl.build(:api_license, :description=>'').should_not be_valid
    end
  end
end 