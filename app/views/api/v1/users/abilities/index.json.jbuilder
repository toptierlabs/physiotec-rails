json.Abilities do |json|
  json.array! @abilities do |ability|
  	json.extract! ability, :id, :permission_id, :action_id, :scope_id
  	json.extract! ability, :language_ids if ability.language_ids.present?
  end
end