require 'spec_helper'

describe "api/v1s/show" do
  before(:each) do
    @api_v1 = assign(:api_v1, stub_model(Api::V1::Users::Ability))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
