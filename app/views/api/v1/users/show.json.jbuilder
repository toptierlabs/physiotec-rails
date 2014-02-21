json.user do |json|
  json.extract! @user, :id, :email, :first_name, :last_name, :api_license_id, :profile_ids, :contexts
  json.contexts @user.contexts
  json.profile_ids @user.profile_ids
  json.abilities do |json|
    json.array! @user.user_abilities.includes(:ability) do |ability|
      json.extract! ability, :id, :permission_id, :action_id, :scope_id
    end
  end

  json.assignable_profiles do |json|
    json.array! @user.assignable_profiles do |profile|
      json.extract! profile, :id, :name
    end
  end

end