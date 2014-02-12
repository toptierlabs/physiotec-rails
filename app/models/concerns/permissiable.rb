module Permissiable

  def can?(action, subject, extra_args = {})
    #sanitize the params
    scope = extra_args[:scope] || nil
    locales = Language.where(locale: extra_args[:locales]).pluck(:id) || []
    return false if extra_args[:locales].present? && (locales.size != extra_args[:locales].size)
    permission = nil
    if ((subject.class == Symbol) || (subject.class == String))
      permission = Permission.where(name: subject).first
      subject = nil
    else
      permission = Permission.where(model_name: subject.class.name).first
    end

    abilities = self.user_abilities
                  .joins(:ability)
                  .where(abilities: { permission_id: permission.id,
                                      action_id: Action.find_by(name: action).id })

    return false unless abilities.present?
    return true if subject.blank? && scope.blank? && locales.blank?
    result = false
    abilities.each do |v|
      if subject.present?
        result = (subject.minimum_scope_for(self) <= Scope.find(v.scope_id))
        result &&= (locales - v.languages.pluck(:id)).empty? if locales.present? && permission.is_translatable?
      elsif scope.present?
        result = v.scope >= scope
      end
      return true if result
    end
    false
  end

end