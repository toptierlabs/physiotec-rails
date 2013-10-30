require 'spec_helper' 

describe AdminUser do 

  context "Valid user" do
    it "has a valid factory" do
      FactoryGirl.create(:admin_user).should be_valid
    end
  end
  
  context "Invalid user" do
    it "should not work with a short password" do
      FactoryGirl.build(:admin_user, :password=>'short').should_not be_valid
    end
    it "should not work with an empty password" do
      FactoryGirl.build(:admin_user, :password=>'').should_not be_valid
    end
    it "should not work with an empty email" do
      FactoryGirl.build(:admin_user, :email=>'').should_not be_valid
    end

    it "should not work with an invalid email" do
      FactoryGirl.build(:admin_user, :email=>'fooo@das').should_not be_valid
    end
    
    it "should not create a user with the same email" do
      @admin_user = FactoryGirl.create(:admin_user)
      @user_with_same_email = @admin_user.dup
      @user_with_same_email.email = @admin_user.email.upcase
      @user_with_same_email.should_not be_valid
    end
  end
end 