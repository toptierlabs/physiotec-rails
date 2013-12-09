require 'spec_helper' 

describe PermissionScopeGroup do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:permission_scope_group).valid?).to be_true
  end

  it "should have a permission" do
    expect( FactoryGirl.build(:permission_scope_group, permission: nil).valid? ).to be_false
  end

  it "should return an error if the permission is empty" do
    expect( FactoryGirl.build(:permission_scope_group, permission: nil) ).to have(1).error_on(:permission_id)
  end
    
  it "should have a scope group" do
    expect( FactoryGirl.build(:permission_scope_group, scope_group: nil).valid? ).to be_false
  end

  it "should return an error if the scope group is empty" do
    expect( FactoryGirl.build(:permission_scope_group, scope_group: nil) ).to have(1).error_on(:scope_group_id)
  end

  it "should be invalid if we have the same permission and scope group in two records" do
    sg = FactoryGirl.create(:permission_scope_group) 
    sg_new = sg.dup
    expect( sg_new.valid? ).to be_false
  end
end 