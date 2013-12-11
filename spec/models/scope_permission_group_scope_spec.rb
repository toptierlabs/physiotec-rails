require 'spec_helper' 

describe ScopePermissionGroupScope do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:scope_permission_group_scope).valid?).to be_true
  end

  it "should have a permission" do
    expect( FactoryGirl.build(:scope_permission_group_scope, scope_permission: nil).valid? ).to be_false
  end

  it "should return an error if the scope permission is empty" do
    expect( FactoryGirl.build(:scope_permission_group_scope, scope_permission: nil) ).to have(1).error_on(:scope_permission_id)
  end
    
  it "should have a scope" do
    expect( FactoryGirl.build(:scope_permission_group_scope, scope: nil).valid? ).to be_false
  end

  it "should return an error if the scope group is empty" do
    expect( FactoryGirl.build(:scope_permission_group_scope, scope: nil) ).to have(1).error_on(:scope_id)
  end

  it "should be invalid if we have the same scope and scope permission in two records" do
    sg = FactoryGirl.create(:scope_permission_group_scope) 
    sg_new = sg.dup
    expect( sg_new.valid? ).to be_false
  end
end 