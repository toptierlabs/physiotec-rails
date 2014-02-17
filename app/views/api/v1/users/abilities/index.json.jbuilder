json.abilities do |json|
  json.array! @abilities do |ability|
  	json.extract! ability, :id, :permission_id, :action_id, :scope_id
  end
end