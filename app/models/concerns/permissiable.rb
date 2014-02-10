module Permissiable

  def can?(action, subject, extra_args = {})
    #sanitize the params
    scope = extra_args.present? ? extra_args[:scope] : nil
    languages = extra_args.present? ? extra_args[:langauges] : []
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
                                      action_id: Action.find_by_name(action).id })

    return false unless abilities.present?
    return true if subject.blank? && scope.blank? && languages.blank?
    puts "llega 1"
    result = false
    abilities.each do |v|
      puts v.to_json
      if subject.present?
        puts subject.minimum_scope_for(self).id
        result = (subject.minimum_scope_for(self) <= Scope.find(v.scope_id))
        result &&= (languages - v.laguages).empty? if languages.present? && permission.is_translatable?
      elsif scope.present?
        result = v.scope >= scope
      end
      return true if result
    end
    false
  end

end