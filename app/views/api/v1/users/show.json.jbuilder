json.User do |json|
  json.extract! @user, :id, :first_name, :last_name, :email
end