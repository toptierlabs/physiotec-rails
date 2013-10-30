require 'spec_helper' 

describe User do 

  context "Valid user" do
    it "has a valid factory" do
      FactoryGirl.create(:user).should be_valid
    end
    it "should work with an empty password" do
      FactoryGirl.build(:user, :password=>'').should be_valid
    end

  end
  
  context "Invalid user" do
    it "should not work with a short password" do
      FactoryGirl.build(:user, :password=>'short').should_not be_valid
    end
    
    it "should not work with an empty email" do
      FactoryGirl.build(:user, :email=>'').should_not be_valid
    end

    it "should not work with an invalid email" do
      FactoryGirl.build(:user, :email=>'fooo@das').should_not be_valid
    end
    
    it "should not create a user with the same email" do
      @user = FactoryGirl.create(:user)
      @user_with_same_email = @user.dup
      @user_with_same_email.email = @user.email.upcase
      @user_with_same_email.should_not be_valid
    end
  end

  context "instance methods" do
    it "password_match? should be false when password and password confirmation differs" do
      FactoryGirl.build(:user, :password=>'notsoshort', :password_confirmation=>'different_password').password_match?.should be_false
    end

    it "password_match? should be false when password and password confirmation are the same" do
      FactoryGirl.build(:user, :password=>'notsoshort', :password_confirmation=>'notsoshort').password_match?.should be_true
    end

    it "password should be required when the user is not confirmed" do 
      user = FactoryGirl.create(:user)
      user.password_required?.should be_false
    end

    it "password should be required when the user is confirmed" do 
      user = FactoryGirl.create(:user, :confirmed_at=>DateTime.now)
      user.password_required?.should be_true
    end
  end

end 