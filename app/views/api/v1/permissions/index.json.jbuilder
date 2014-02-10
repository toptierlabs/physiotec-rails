json.Permissions do |json|
  json.array! @permissions do |permission|
    json.extract! permission, :id, :name, :minimum_scope_id, :maximum_scope_id
    json.translatable permission.is_translatable?
  end
end