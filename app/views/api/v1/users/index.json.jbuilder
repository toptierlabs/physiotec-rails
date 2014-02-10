json.Users do |json|
  json.array! @users do |user|
  	json.extract! user, :id, :first_name, :last_name, :email
  end
end