json.user do |json|
  json.extract! @user, :id, :email, :first_name, :last_name, :api_license_id, :profile_ids, :contexts
  json.contexts @user.contexts
  json.profile_ids @user.profile_ids
  json.abilities do |json|
    json.array! @user.user_abilities do |ability|
      json.extract! ability, :id, :permission_id, :action_id, :scope_id
      json.extract! ability, :language_ids if ability.language_ids.present?
    end
  end
end