require 'spec_helper'

describe Api::V1::ScopePermissionsController do
  describe "GET index" do
    it "assigns @scope_permissions" do
      get :index
      expect(assigns(:scope_permissions)).not_to be_nil
    end
  end
end
