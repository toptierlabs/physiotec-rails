require 'spec_helper' 

describe ProfileScopePermission do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:profile_scope_permission).valid?).to be_true
  end

  it "should have a permission" do
    expect( FactoryGirl.build(:profile_scope_permission, profile: nil).valid? ).to be_false
  end

  it "should return an error if the profile is empty" do
    expect( FactoryGirl.build(:profile_scope_permission, profile: nil) ).to have(1).error_on(:profile_id)
  end
    
  it "should have a scope permission" do
    expect( FactoryGirl.build(:profile_scope_permission, scope_permission: nil).valid? ).to be_false
  end

  it "should return an error if the scope permission is empty" do
    expect( FactoryGirl.build(:profile_scope_permission, scope_permission: nil) ).to have(1).error_on(:scope_permission_id)
  end

  it "should be invalid if we have the same profile and scope permission in two records" do
    sg = FactoryGirl.create(:profile_scope_permission) 
    sg_new = sg.dup
    expect( sg_new.valid? ).to be_false
  end
end 