json.permission do |json|
    json.extract! @permission, :id, :name
    json.translatable @permission.is_translatable?
    json.assignable @permission.is_assignable?
    json.minimum_scope do
      json.extract! Scope.find(@permission.minimum_scope_id), :id, :name
    end
    json.maximum_scope do
      json.extract! Scope.find(@permission.maximum_scope_id), :id, :name
    end
end