ActiveAdmin.register ProfilesScope do
  index do
    column :id
    column :profile
    column :scope
    default_actions
  end
  config.sort_order = "profile_id_asc"
end
