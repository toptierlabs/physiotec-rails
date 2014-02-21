json.profiles do |json|
  json.array! @profiles do |profile|
  	json.extract! profile, :id, :name
  end
end