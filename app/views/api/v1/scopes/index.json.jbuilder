json.scopes do |json|
  json.array! @scopes.all do |scope|
  	json.extract! scope, :id, :name
  end
end