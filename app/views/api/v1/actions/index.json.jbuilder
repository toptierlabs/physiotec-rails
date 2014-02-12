json.actions do |json|
  json.array! @actions do |action|
  	json.extract! action, :id, :name
  end
end