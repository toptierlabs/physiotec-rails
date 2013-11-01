ActiveAdmin.register UsersScopes do
  index do
    column :id
    column :user
    column :scope
    default_actions
  end
  config.sort_order = "user_id_asc"
end
