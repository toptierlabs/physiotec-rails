json.users do |json|
  json.array! @users do |user|
  	json.extract! user, :id, :email, :first_name, :last_name
  end
end