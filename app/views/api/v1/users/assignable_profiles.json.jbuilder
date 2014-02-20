json.assignable_profiles do |json|
  json.array! @assignable_profiles do |profile|
    json.extract! profile, :id, :name
  end
end