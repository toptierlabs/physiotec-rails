require 'spec_helper' 

describe UserScopePermission do 

  it "has a valid factory" do
    expect(FactoryGirl.create(:user_scope_permission).valid?).to be_true
  end

  it "should have a permission" do
    expect( FactoryGirl.build(:user_scope_permission, scope_permission: nil).valid? ).to be_false
  end

  it "should return an error if the scope permission is empty" do
    expect( FactoryGirl.build(:user_scope_permission, scope_permission: nil) ).to have(1).error_on(:scope_permission)
  end
    
  it "should have a user" do
    expect( FactoryGirl.build(:user_scope_permission, user: nil).valid? ).to be_false
  end

  it "should return an error if the scope group is empty" do
    expect( FactoryGirl.build(:user_scope_permission, user: nil) ).to have(1).error_on(:user)
  end

  it "should be invalid if we have the same profile and scope permission in two records" do
    sp = FactoryGirl.create(:user_scope_permission) 
    sp_new = sp.dup
    expect( sp_new.valid? ).to be_false
  end
end 