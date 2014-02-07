# == Schema Information
#
# Table name: licenses
#
#  id              :integer          not null, primary key
#  maximum_clinics :integer
#  maximum_users   :integer
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  api_license_id  :integer
#  company_name    :string(255)
#  users_count     :integer          default(0), not null
#

require 'spec_helper' 

describe License do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:license).valid?).to be_true
  end

  it "should have a first name" do
    license = FactoryGirl.build(:license, :first_name=>'')
    expect(license.valid?).to be_false
    expect(license).to have(1).error_on(:first_name)
  end

  it "should have a last name" do
    license = FactoryGirl.build(:license, :last_name=>'')
    expect(license.valid?).to be_false
    expect(license).to have(1).error_on(:last_name)
  end

  it "should have a email" do
    license = FactoryGirl.build(:license, :email=>'')
    expect(license.valid?).to be_false
    expect(license).to have(1).error_on(:email)
  end

  it "should have a unique email within a api license" do
    license = FactoryGirl.create(:license)
    new_license = FactoryGirl.build(:license, api_license: license.api_license, email: license.email)

    expect(new_license.valid?).to be_false
    expect(new_license).to have(1).error_on(:email)
  end

  it "can have same email on different api licenses" do
    license = FactoryGirl.create(:license)
    new_license = FactoryGirl.build(:license, email: license.email)

    expect(new_license.valid?).to be_true
    expect(new_license).to have(0).error_on(:email)
  end

 
end 
