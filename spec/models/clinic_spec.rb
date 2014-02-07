# == Schema Information
#
# Table name: clinics
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  license_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#

require 'spec_helper' 

describe Clinic do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:clinic).valid?).to be_true
  end

  it "should have a name" do
    clinic = FactoryGirl.build(:clinic, :name=>'')
    expect(clinic.valid?).to be_false
    expect(clinic).to have(1).error_on(:name)
  end

  it "should have a unique name within a license" do
    clinic = FactoryGirl.create(:clinic)
    new_clinic = FactoryGirl.build(:clinic, license: clinic.license, name: clinic.name)

    expect(new_clinic.valid?).to be_false
    expect(new_clinic).to have(1).error_on(:name)
  end

  it "can have same name on different licenses" do
    clinic = FactoryGirl.create(:clinic)
    new_clinic = FactoryGirl.build(:clinic, name: clinic.name)

    expect(new_clinic.valid?).to be_true
    expect(new_clinic).to have(0).error_on(:name)
  end

  it "should return itself with #clinic" do 
    clinic = FactoryGirl.build(:clinic)
    expect(clinic.clinic).to eql(clinic)
  end

  it "should return the clinics api license with #api_license" do 
    clinic = FactoryGirl.build(:clinic)
    expect(clinic.api_license).to eql(clinic.license.api_license)
  end
 
end 
