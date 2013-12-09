require 'spec_helper' 

describe ApiLicense do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:api_license).valid?).to be_true
  end

  it "should not work with an empty name" do
    expect(FactoryGirl.build(:api_license, :name=>'').valid?).to be_false
  end

  it "should not work with an empty description" do
    expect(FactoryGirl.build(:api_license, :description=>'').valid?).to be_false
  end

  it "should have a unique name" do
    api = FactoryGirl.create(:api_license)
    api_new = FactoryGirl.build(:api_license, name: api.name)

    expect(api_new.valid?).to be_false
  end

  it "should return an error on the name" do
    api = FactoryGirl.create(:api_license)
    api_new = FactoryGirl.build(:api_license, name: api.name)

    expect(api_new).to have(1).error_on(:name)
  end

  it "should generate api key" do
    expect(FactoryGirl.create(:api_license).public_api_key.present?).to be_true
  end

  it "should generate a secret key" do
    expect(FactoryGirl.create(:api_license).secret_api_key.present?).to be_true
  end

  it "should not have repeated api keys" do
    api = FactoryGirl.create(:api_license)
    api_new = FactoryGirl.create(:api_license)
    api_new.secret_api_key = api.secret_api_key

    expect(api_new.valid?).to be_false
  end

  it "should have an error on the api key if repeated" do
    api = FactoryGirl.create(:api_license)
    api_new = FactoryGirl.create(:api_license)
    api_new.public_api_key = api.public_api_key

    expect(api_new).to have(1).error_on(:public_api_key)
  end


  it "should #generate_api_keys" do
    api = FactoryGirl.create(:api_license)
    public_key = api.public_api_key
    secret_key = api.secret_api_key

    api.generate_api_keys

    expect(api.public_api_key).not_to eql(public_key)
    expect(api.secret_api_key).not_to eql(secret_key)
  end

  it "should return itself with #api_license" do 
    api = FactoryGirl.build(:api_license)
    expect(api.api_license).to eql(api)
  end

end 