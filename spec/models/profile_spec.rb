# == Schema Information
#
# Table name: profiles
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#

require 'spec_helper'

describe Profile do
  it "has a valid factory" do
    expect { FactoryGirl.build(:profile).valid? }.to be_true
  end

  it "should have a name" do
    expect(FactoryGirl.build(:profile, name: '').valid?).to be_false
  end

  it "should return an error if the name is empty" do
    expect(FactoryGirl.build(:profile, name: '')).to have(1).error_on(:name)
  end

  it "should have a api license" do
    expect(FactoryGirl.build(:profile, api_license: nil).valid?).to be_false
  end

  it "should return an error if the api_license is empty" do
    expect(FactoryGirl.build(:profile, api_license: nil)).to have(1).error_on(:api_license)
  end
  
  it "should not be valid if we have another profile with the same name for the same api license" do
    api_license = FactoryGirl.create(:api_license, name: 'API')
    prof = FactoryGirl.create(:profile, api_license: api_license)
    new_prof = prof.dup

    expect(new_prof.valid?).to be_false
  end

  it "can exist two permissions with the same name on different api licenses" do
    api_license = FactoryGirl.create(:api_license, name: 'API')
    prof = FactoryGirl.create(:profile, api_license: api_license)
    new_prof = prof.dup
    new_prof.api_license = FactoryGirl.create(:api_license, name: 'New API')

    expect(new_prof.valid?).to be_true
  end


  
end



