require 'spec_helper'

describe "api/v1s/edit" do
  before(:each) do
    @api_v1 = assign(:api_v1, stub_model(Api::V1::Users::Ability))
  end

  it "renders the edit api_v1 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", api_v1_path(@api_v1), "post" do
    end
  end
end
