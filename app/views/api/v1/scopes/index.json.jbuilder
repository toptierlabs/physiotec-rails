json.Scopes do |json|
  json.array! @scopes do |scope|
  	json.extract! scope, :id, :name
  end
end