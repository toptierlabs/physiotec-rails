require 'spec_helper'

describe "Api::V1::Users::Abilities" do
  describe "GET /api_v1_users_abilities" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get api_v1_users_abilities_path
      response.status.should be(200)
    end
  end
end
