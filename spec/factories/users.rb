# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)      not null
#  last_name                :string(255)      not null
#  api_license_id           :integer          not null
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  unconfirmed_email        :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  session_token            :string(255)
#  session_token_created_at :date
#  maximum_context_cache_id :integer          default(1), not null
#

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
