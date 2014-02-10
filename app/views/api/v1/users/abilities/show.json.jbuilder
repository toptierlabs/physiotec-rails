json.Ability do |json|
  json.extract! @ability, :id
  json.permission do
    json.extract! @ability.permission, :id, :name
  end
  json.action do
    json.extract! @ability.action, :id, :name
  end

  json.scope do
    json.extract! @ability.scope, :id, :name
  end


  if @ability.language_ids.present?
  	json.language_ids @ability.language_ids
  end
end