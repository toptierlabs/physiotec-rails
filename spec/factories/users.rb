FactoryGirl.define do 
  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  factory :user do 
    email { FactoryGirl.generate(:user_email) }
    first_name "Myname"
    last_name "MyLast name"
    password "DoeDoe12" 
    
    api_license ApiLicense.find_by_name('API test name')
    context ApiLicense.find_by_name('API test name')
  end 

end 