json.ability do |json|
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

end