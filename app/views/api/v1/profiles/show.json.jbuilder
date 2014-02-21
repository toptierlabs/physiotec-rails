json.profile do |json|
  json.extract! @profile, :id, :name, :destination_profile_ids, :profile_abilities
end